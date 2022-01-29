import ComposableArchitecture

public struct AppFeatureState: Equatable {

    public init() { }

    let welcomeMessage: String = "Hello!"
}

public enum AppFeatureAction: Equatable {
    case first
}

public struct AppEnvironment {
    public init() { }
}

public let appReducer: Reducer<AppFeatureState, AppFeatureAction, AppEnvironment> = Reducer.combine(
)

private let appReducerCore: Reducer<AppFeatureState, AppFeatureAction, AppEnvironment> = Reducer
{ state, action, environment in
    switch action {
    default:
        return .none
    }
}
