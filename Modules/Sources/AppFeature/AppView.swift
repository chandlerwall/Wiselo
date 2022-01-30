import ComposableArchitecture
import Core
import HostFeature
import SwiftUI

public struct AppView: View {

    struct ViewState: Equatable {
        let status: AppStartupStatus
        let user: User?

        init(state: AppFeatureState) {
            self.status = state.status
            self.user = state.user
        }
    }

    let store: Store<AppFeatureState, AppFeatureAction>
    @ObservedObject var viewStore: ViewStore<ViewState, AppFeatureAction>

    public init(
        store: Store<AppFeatureState, AppFeatureAction>
    ) {
        self.store = store
        self.viewStore = ViewStore(self.store.scope(state: ViewState.init(state:)))
    }

    public var body: some View {
        ZStack {
            switch self.viewStore.status {
            case .uninitialized, .initializing, .restoring:
                Image(systemName: "sparkles")
                    .font(.largeTitle)

            case .refreshing, .preparing:
                VStack {
                    if let user = self.viewStore.user {
                        Text("Welcome back, \(user.name)!")
                            .padding(.horizontal)
                    } else {
                        Text("Welcome back!")
                            .padding(.horizontal)
                    }

                    if self.viewStore.status == .refreshing {
                        ProgressView()
                            .padding()
                            .frame(height: 65)
                    } else {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                            .padding()
                            .frame(height: 65)
                    }
                }
                .font(.largeTitle)
                .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity))

            case .done:
                IfLetStore(
                    self.store.scope(
                        state: \.host,
                        action: { .host($0) }
                    )
                ) { hostStore in
                    HostView(store: hostStore)
                        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity))
                } else: {
                    // TODO: This code cannot be reached.
                    // - When/if this path is possible, reconsider the use of `Spacer`.
                    Spacer()
                }

            case let .error(message):
                VStack {
                    Image(systemName: "exclamationmark.circle")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                        .padding()

                    Text(message)
                        .font(.title3)
                }
            }
        }
    }
}

#if DEBUG

import PreviewHelpers

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        func buildPreview(_ status: AppStartupStatus) -> some View {
            var initialState = AppFeatureState()
            initialState.status = status
            initialState.user = .init(name: "Sarah")
            initialState.host = .mock

            return AppView(
                store: Store(
                    initialState: initialState,
                    reducer: Reducer<AppFeatureState, AppFeatureAction, Void>.empty,
                    environment: ()
                )
            )
        }

        return Group {
            DevicePreview { buildPreview(.done) }
            DevicePreview { buildPreview(.uninitialized) }
            DevicePreview { buildPreview(.restoring) }
            DevicePreview { buildPreview(.refreshing) }
            DevicePreview { buildPreview(.preparing) }
            DevicePreview { buildPreview(.error(message: "Uh oh!")) }
        }
    }
}

#endif
