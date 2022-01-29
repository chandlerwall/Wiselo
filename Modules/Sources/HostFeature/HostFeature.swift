import Combine
import ComposableArchitecture
import Core

public struct HostFeatureState: Equatable {

    public init() { }

    // FIXME: variable; use real state for each property.
    var rooms: [Room] = []
    var sections: [SectionPreference] = [] // FIXME: maybe rename to include preferences in name
//    var statuses: [TableStatus] = []

    var tables: [Table] = []

    var searchText: String = ""

    var tablesByRoom: [TableGroup] {
        self.rooms.map { room in
            TableGroup(
                type: .room(room),
                tables: self.tables.filter { $0.roomId == room.id }
            )
        }
    }

    var tablesBySection: [TableGroup] {
        self.sections.map { section in
            TableGroup(
                type: .section(section),
                tables: self.tables.filter { $0.preferenceIds.contains(section.id) }
            )
        }
    }

    var tableGroups: [TableGroup] {
        // FIXME: Consider sorting logic (sort by total available?)
        // FIXME: Consider impact of user search query.
        self.tablesByRoom + self.tablesBySection
    }

    // available tables
    // search results
}

public enum HostFeatureAction: Equatable {
    case reload
    case restaurantResponse(Result<RestaurantState, APIError>)
    case roomResponse(Result<[Room], APIError>)
    case didReceiveTableStatus(TableStatus)
}

public struct HostEnvironment {
    public init(
        hostService: HostService,
        mainQueue: AnySchedulerOf<DispatchQueue>
    ) {
        self.hostService = hostService
        self.mainQueue = mainQueue
    }

    let hostService: HostService
    let mainQueue: AnySchedulerOf<DispatchQueue>

    func restaurant() -> Effect<RestaurantState, APIError> {
        Publishers.Zip4(
            self.hostService.rooms(),
            self.hostService.sectionPreferences(),
            self.hostService.tables(),
            self.hostService.tableStatuses()
        )
        .map(RestaurantState.init(from:))
        .eraseToEffect()
    }
}

public let hostReducer: Reducer<HostFeatureState, HostFeatureAction, HostEnvironment> = Reducer.combine(
    hostReducerCore
)

private let hostReducerCore: Reducer<HostFeatureState, HostFeatureAction, HostEnvironment> = Reducer
{ state, action, environment in
    switch action {
    case .reload:
        return environment.restaurant()
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(HostFeatureAction.restaurantResponse)

    case let .restaurantResponse(.success(restaurant)):
        state.rooms = restaurant.rooms.sorted(on: \.name)
        state.sections = restaurant.sections.sorted(on: \.name)
//        state.statuses = restaurant.statuses
        state.tables = restaurant.tables.sorted(on: \.name)
        // FIXME: Filter data? Remove deleted tables. Ignore closed tables.
        return .none

    case .restaurantResponse(.failure(_)):
        // FIXME: Handle errors.
        return .none

    case .roomResponse(_):
        return .none

    case .didReceiveTableStatus(_):
        return .none
    }
}

typealias RestaurantResponse = (rooms: [RoomResponse], sections: [SectionPreferenceResponse], tables: [TableResponse], statuses: [TableStatusResponse])

public struct RestaurantState: Equatable {
    // FIXME: Move into better location.
    let rooms: [Room]
    let sections: [SectionPreference]
    let tables: [Table]
//    let statuses: [TableStatus]
}

extension RestaurantState {
    init(from response: RestaurantResponse) {
        let rooms = response.rooms.map(Room.init(from:))
        let sections = response.sections.map(SectionPreference.init(from:))
        let tables = response.tables.map { tableResponse in
            Table(
                tableResponse: tableResponse,
                statusResponses: response.statuses.filter { $0.table_id == tableResponse.table_id }
            )
        }

        self.init(rooms: rooms, sections: sections, tables: tables)
    }
}

struct TableGroup: Equatable, Identifiable {
    let type: `Type` // FIXME: private
    let tables: [Table]

    var id: String { self.type.id }
    var name: String { self.type.name }

    enum `Type`: Equatable, Identifiable {
        case firstAvailable
        case room(Room)
        case section(SectionPreference)

        var id: String {
            switch self {
            case .firstAvailable:
                return "firstAvailable"

            case let .room(room):
                return "room" + room.id

            case let .section(section):
                return "section" + section.id
            }
        }

        var name: String {
            switch self {
            case .firstAvailable:
                return "First Available"

            case let .room(room):
                return room.name

            case let .section(section):
                return section.name
            }
        }
    }
}
