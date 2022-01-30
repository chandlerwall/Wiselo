import Combine
import ComposableArchitecture
import Core
import HostFeature

public struct AppFeatureState: Equatable {

    public init() { }

    var startupStatus: StartupStatus = .uninitialized // FIXME: rename to status.
    var host: HostFeatureState?
}

public enum AppFeatureAction: Equatable {
    case didFinishLaunching

    case initialize
    case restoreSession
    case refreshData
    case restaurantResponse(Result<Restaurant, APIError>)
    case prepareToLaunch
    case launch

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

public let appReducer: Reducer<AppFeatureState, AppFeatureAction, AppEnvironment> = Reducer.combine(
    hostReducer.optional().pullback(
        state: \AppFeatureState.host,
        action: /AppFeatureAction.host,
        environment: { _ in }
    ),
    appReducerCore
)

private let appReducerCore: Reducer<AppFeatureState, AppFeatureAction, AppEnvironment> = Reducer
{ state, action, environment in
    switch action {
    case .didFinishLaunching:
        state.startupStatus = .uninitialized
        return Effect(value: .initialize).deferred(for: 0.25, scheduler: environment.mainQueue.animation())

    case .initialize:
        state.startupStatus = .initializing
        return Effect(value: .restoreSession).deferred(for: 0.25, scheduler: environment.mainQueue.animation())

    case .restoreSession:
        state.startupStatus = .restoring
        return Effect(value: .refreshData).deferred(for: 0.25, scheduler: environment.mainQueue.animation())

    case .refreshData:
        state.startupStatus = .refreshing
        return environment.restaurant()
            .deferred(for: 1, scheduler: environment.mainQueue) // FIXME: Document
            //.flatMap { _ in Effect<Restaurant, APIError>(error: APIError.response) } // FIXME: Document.
            .receive(on: environment.mainQueue.animation())
            .catchToEffect()
            .map(AppFeatureAction.restaurantResponse)

    case let .restaurantResponse(.success(restaurant)):
        state.host = .init(restaurant: restaurant)
        return Effect(value: .prepareToLaunch)

    case .restaurantResponse(.failure(_)):
        state.startupStatus = .error(message: "Unable to refresh.")
        state.host = nil
        return .none

    case .prepareToLaunch:
        state.startupStatus = .preparing
        return Effect(value: .launch).deferred(for: 0.5, scheduler: environment.mainQueue.animation())

    case .launch:
        state.startupStatus = .done
        return .none

    case .host(_):
        return .none
    }
}
