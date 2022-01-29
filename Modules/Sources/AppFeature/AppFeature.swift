import ComposableArchitecture
import Core
import HostFeature

public struct AppFeatureState: Equatable {

    public init() { }

    let welcomeMessage: String = "Hello!"
    var status: LoadingStatus = .uninitialized

    var host: HostFeatureState?
}

public enum AppFeatureAction: Equatable {
    case didFinishLaunching
    case restaurantResponse(Result<RestaurantState, APIError>)

    case host(HostFeatureAction)
}

public struct AppEnvironment {

    public init(
        hostService: HostService,
        mainQueue: AnySchedulerOf<DispatchQueue>
    ) {
        self.hostService = hostService
        self.mainQueue = mainQueue
    }

    let hostService: HostService
    let mainQueue: AnySchedulerOf<DispatchQueue>
}

public let appReducer: Reducer<AppFeatureState, AppFeatureAction, AppEnvironment> = Reducer.combine(
    hostReducer.optional().pullback(
        state: \AppFeatureState.host,
        action: /AppFeatureAction.host,
        environment: \.host
    ),
    appReducerCore
)
    .debug()

private let appReducerCore: Reducer<AppFeatureState, AppFeatureAction, AppEnvironment> = Reducer
{ state, action, environment in
    switch action {
    case .didFinishLaunching:
        state.status = .loading
        state.host = .init()
        return Effect(value: .host(.reload))

    case .restaurantResponse(_):
        // FIXME: Implement
        return .none

    case .host(_):
        return .none
    }
}

extension AppEnvironment {
    var host: HostEnvironment { .init(hostService: self.hostService, mainQueue: self.mainQueue) }
}
