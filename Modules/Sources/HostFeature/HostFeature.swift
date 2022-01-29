import ComposableArchitecture

public struct HostFeatureState: Equatable {

    public init() { }

    let welcomeMessage: String = "Hello!"
}

public enum HostFeatureAction: Equatable {
    case first
}

public struct HostEnvironment {
    public init() { }
}

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
