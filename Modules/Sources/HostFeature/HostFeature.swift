import Combine
import ComposableArchitecture
import Core

public struct HostFeatureState: Equatable {

    public init() { }

    // FIXME: variable; use real state for each property.
    var rooms: [Room] = []
    var sections: [SectionPreference] = []
    var statuses: [TableStatus] = []
    var tables: [Table] = []

    var searchText: String = ""

    var tableGroups: [TableGroup] {
        []
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
            self.hostService.rooms().map { $0.map(Room.init(from:)) },
            self.hostService.sectionPreferences().map { $0.map(SectionPreference.init(from:)) },
            self.hostService.tables().map { $0.map(Table.init(from:)) },
            self.hostService.tableStatuses().map { $0.compactMap(TableStatus.init(from:)) }
        )
        .map(RestaurantState.init(rooms:sections:tables:statuses:))
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
        state.rooms = restaurant.rooms
        state.sections = restaurant.sections
        state.statuses = restaurant.statuses
        state.tables = restaurant.tables
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

public struct RestaurantState: Equatable {
    // FIXME: Move into better location.
    let rooms: [Room]
    let sections: [SectionPreference]
    let tables: [Table]
    let statuses: [TableStatus]
}

struct TableGroup: Equatable, Identifiable {
    let type: `Type`
    let tables: [Table]

    var id: String { self.type.id }

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
    }
}
