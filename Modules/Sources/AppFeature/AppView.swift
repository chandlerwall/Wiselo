import ComposableArchitecture
import Core
import DesignLanguage
import HostFeature
import SwiftUI

public struct AppView: View {

    struct ViewState: Equatable {
        let startupStatus: StartupStatus

        init(state: AppFeatureState) {
            self.startupStatus = state.startupStatus
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
            switch self.viewStore.startupStatus {
            case .uninitialized, .initializing, .restoring:
                Image(systemName: "sparkles")
                    .font(.largeTitle)

            case .refreshing, .preparing:
                VStack {
                    Text("Welcome back, firstName!")
                        .padding(.horizontal)

                    Group {
                    if self.viewStore.startupStatus == .refreshing {
                        ProgressView()
                            .padding()
                    } else {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                            .padding()
                    }
                    }
                    .frame(height: 50)
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
                    Spacer() // FIXME: Not spacer
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
        func buildPreview(_ status: StartupStatus) -> some View {
            var initialState = AppFeatureState()
            initialState.startupStatus = status
            initialState.host = .mock

            // FIXME: Document ZStack.
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
