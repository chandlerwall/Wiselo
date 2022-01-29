import ComposableArchitecture
import DesignLanguage
import SwiftUI

public struct AppView: View {

    struct ViewState: Equatable {
        let welcomeMessage: String

        init(state: AppFeatureState) {
            self.welcomeMessage = state.welcomeMessage
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
        Text(self.viewStore.welcomeMessage)
            .font(.largeTitle)
            .padding()
    }
}

// FIXME: Preview.
