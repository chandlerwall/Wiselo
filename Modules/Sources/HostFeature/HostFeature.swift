import ComposableArchitecture

public struct HostFeatureState: Equatable {

    public init() { }

    // FIXME: variable; use real state for each property.
    var rooms: [Room] = []
    var statuses: [TableStatus] = []
    var tables: [Table] = []

    var searchText: String = ""

    // available tables
    // search results
}

public enum HostFeatureAction: Equatable {
    case reload
    case didReceiveTableStatus(TableStatus)
}

public typealias HostEnvironment = HostService

public let hostReducer: Reducer<HostFeatureState, HostFeatureAction, HostEnvironment> = Reducer.combine(
    hostReducerCore
)

private let hostReducerCore: Reducer<HostFeatureState, HostFeatureAction, HostEnvironment> = Reducer
{ state, action, environment in
    switch action {
    default:
        return .none
    }
}
