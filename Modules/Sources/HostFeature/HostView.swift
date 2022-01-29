import ComposableArchitecture
import DesignLanguage
import SwiftUI

public struct HostView: View {

    struct ViewState: Equatable {
        init(state: HostFeatureState) {

        }
    }

    let store: Store<HostFeatureState, HostFeatureAction>
    @ObservedObject var viewStore: ViewStore<ViewState, HostFeatureAction>

    public init(
        store: Store<HostFeatureState, HostFeatureAction>
    ) {
        self.store = store
        self.viewStore = ViewStore(self.store.scope(state: ViewState.init(state:)))
    }

    public var body: some View {
        VStack {
            SearchInputView(
                title: "Search Input - Number of Guests",
                placeholder: "# of Guests",
                text: .constant("")
            )

            GroupedTableListView()
        }
    }
}

#if DEBUG

import PreviewHelpers

struct HostView_Previews: PreviewProvider {
    static var previews: some View {
        DevicePreview {
            HostView(
                store: Store(
                    initialState: .init(),
                    reducer: hostReducer,
                    environment: .mock
                )
            )
        }
    }
}

#endif
