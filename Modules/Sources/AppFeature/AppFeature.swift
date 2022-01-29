import ComposableArchitecture
import Core

public struct AppFeatureState: Equatable {

    public init() { }

    let welcomeMessage: String = "Hello!"
    var hostStatus: LoadingStatus = .uninitialized
}

public enum AppFeatureAction: Equatable {
    case first
}

public struct AppEnvironment {
    public init() { }
}

public let appReducer: Reducer<AppFeatureState, AppFeatureAction, AppEnvironment> = Reducer.combine(
    appReducerCore
)

private let appReducerCore: Reducer<AppFeatureState, AppFeatureAction, AppEnvironment> = Reducer
{ state, action, environment in
    switch action {
    default:
        return .none
    }
}
