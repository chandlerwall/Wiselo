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
    case didFinishLaunching

    case host(HostFeatureAction)
}

public struct AppEnvironment {

    public init(
        hostService: HostService
    ) {
        self.hostService = hostService
    }

    let hostService: HostService
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
    case .didFinishLaunching:
        state.host = .init()
        return .none

    case .host(_):
        return .none
    }
}

extension AppEnvironment {
    var host: HostEnvironment { self.hostService }
}

#if DEBUG

extension AppEnvironment {
    static let mock: Self = .init(
        hostService: .mock
    )
}

#endif
