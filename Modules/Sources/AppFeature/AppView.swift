import ComposableArchitecture
import Core
import DesignLanguage
import SwiftUI
import HostFeature

public struct AppView: View {

    struct ViewState: Equatable {
        let welcomeMessage: String
        let hostStatus: LoadingStatus

        init(state: AppFeatureState) {
            self.welcomeMessage = state.welcomeMessage
            self.hostStatus = state.hostStatus
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
        IfLetStore(
            self.store.scope(
                state: \.host,
                action: { .host($0) }
            )
        ) { hostStore in
            HostView(store: hostStore)
        } else: {
            Text(self.viewStore.welcomeMessage)
                .font(.largeTitle)
                .padding()
                .loading(self.viewStore.hostStatus)
        }
    }
}

#if DEBUG

import PreviewHelpers

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        DevicePreview {
            AppView(
                store: Store(
                    initialState: .init(),
                    reducer: appReducer,
                    environment: .mock
                )
            )
        }
    }
}

#endif
