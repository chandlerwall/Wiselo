import Combine
import ComposableArchitecture
import Core
import HostFeature

public struct AppFeatureState: Equatable {

    public init() { }

    let welcomeMessage: String = "Hello!" // FIXME: Remove or repurpose to describe loading process.
    var status: LoadingStatus = .uninitialized

    var host: HostFeatureState?
}

public enum AppFeatureAction: Equatable {
    case didFinishLaunching
    case restaurantResponse(Result<Restaurant, APIError>)

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
        state.status = .loading
        return environment.restaurant()
            .deferred(for: 3, scheduler: environment.mainQueue) // FIXME: Document
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(AppFeatureAction.restaurantResponse)

    case let .restaurantResponse(.success(restaurant)):
        state.status = .done
        state.host = .init(restaurant: restaurant)
        return .none

    case .restaurantResponse(.failure(_)):
        state.status = .error
        state.host = nil
        return .none

    case .host(_):
        return .none
    }
}
