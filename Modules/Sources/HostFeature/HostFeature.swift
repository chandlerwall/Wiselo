import Combine
import ComposableArchitecture
import Core

public struct HostFeatureState: Equatable {

    public init(
        rooms: [Room] = [],
        sections: [SectionPreference] = [],
        tables: [Table] = [],
        searchText: String = ""
    ) {
        self.rooms = rooms
        self.sections = sections
        self.tables = tables
        self.searchText = searchText
    }

    var rooms: [Room]
    var sections: [SectionPreference] // FIXME: maybe rename to include preferences in name
//    var statuses: [TableStatus] = [] // FIXME: Should statuses be persisted with feature state?

    var tables: [Table]

    var searchText: String

    var tableGroups: [TableGroup] {
        // FIXME: Consider sorting logic (sort by total available?)
        [self.firstAvailable] + self.tablesByRoom + self.tablesBySection
    }

    private var firstAvailable: TableGroup {
        let partySize = Int(self.searchText) ?? 0
        let tables = partySize > 0
            ? self.tables.filter { $0.minCapacity >= partySize && $0.maxCapacity <= partySize }
            : self.tables

        // FIXME: Limit to top 3 tables. Sort before prefixing.
        let availableTables = tables.filter(\.status.isAvailable)

        return TableGroup(type: .firstAvailable, tables: availableTables)
    }

    private var tablesByRoom: [TableGroup] {
        self.rooms.map { room in
            TableGroup(
                type: .room(room),
                tables: self.tables.filter { $0.roomId == room.id }
            )
        }
    }

    private var tablesBySection: [TableGroup] {
        self.sections.map { section in
            TableGroup(
                type: .section(section),
                tables: self.tables.filter { $0.preferenceIds.contains(section.id) }
            )
        }
    }
}

public enum HostFeatureAction: Equatable {
    case reload
    case restaurantResponse(Result<Restaurant, APIError>)
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

    func restaurant() -> Effect<Restaurant, APIError> {
        Publishers.Zip4(
            self.hostService.rooms(),
            self.hostService.sectionPreferences(),
            self.hostService.tables(),
            self.hostService.tableStatuses()
        )
        .map(Restaurant.init(from:))
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
        // FIXME: Prefer sorting in View if practical (more consistent results between features and previews).
        state.rooms = restaurant.rooms.sorted(on: \.name)
        state.sections = restaurant.sections.sorted(on: \.name)
//        state.statuses = restaurant.statuses
        state.tables = restaurant.tables.sorted(on: \.name) // FIXME: tables should be sorted on capacity
        // FIXME: Filter data? Remove deleted tables. Ignore closed tables.
        return .none

    case .restaurantResponse(.failure(_)):
        // FIXME: Handle errors.
        return .none

    case .didReceiveTableStatus(_):
        return .none
    }
}


#if DEBUG

extension HostFeatureState {
    static let mock = HostFeatureState(
        rooms: .mock,
        sections: .mock,
        tables: .mock
    )
}

#endif
