import ComposableArchitecture
import Core
import DesignLanguage
import HostFeature
import SwiftUI

public struct AppView: View {

    struct ViewState: Equatable {
        let welcomeMessage: String
        let status: LoadingStatus

        init(state: AppFeatureState) {
            self.welcomeMessage = state.welcomeMessage
            self.status = state.status
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
        // FIXME: Implement loading/startup message or remove unnecessary hierarchy.
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
                .loading(self.viewStore.status)
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
                    reducer: Reducer<AppFeatureState, AppFeatureAction, Void>.empty,
                    environment: ()
                )
            )
        }
    }
}

#endif
