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
            self.hostService.tableStatuses().map { $0.map(TableStatus.init(from:)) }
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

    case .restaurantResponse(_):
        return .none

    case .roomResponse(_):
        return .none

    case .didReceiveTableStatus(_):
        return .none
    }
}

public struct RestaurantState: Equatable {
    let rooms: [Room]
    let sections: [SectionPreference]
    let tables: [Table]
    let statuses: [TableStatus]
}
