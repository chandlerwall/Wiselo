import ComposableArchitecture
import Core
import HostFeature

public struct AppFeatureState: Equatable {

    public init() { }

    let welcomeMessage: String = "Hello!"
    var hostStatus: LoadingStatus = .uninitialized

    var host: HostFeatureState?
}

public enum AppFeatureAction: Equatable {
    case first

    case host(HostFeatureAction)
}

public struct AppEnvironment {
    public init() { }
}

public let appReducer: Reducer<AppFeatureState, AppFeatureAction, AppEnvironment> = Reducer.combine(
    hostReducer.optional().pullback(
        state: \AppFeatureState.host,
        action: /AppFeatureAction.host,
        environment: \.host
    ),
    appReducerCore
)

private let appReducerCore: Reducer<AppFeatureState, AppFeatureAction, AppEnvironment> = Reducer
{ state, action, environment in
    switch action {
    default:
        // FIXME: Implement.
        return .none
    }
}

extension AppEnvironment {
    var host: HostEnvironment {
        HostEnvironment() // FIXME: Implement environment transform.
    }
}
