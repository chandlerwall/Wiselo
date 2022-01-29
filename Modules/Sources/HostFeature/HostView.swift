import ComposableArchitecture
import DesignLanguage
import SwiftUI

public struct HostView: View {

    struct ViewState: Equatable {
        let tableGroups: [TableGroup]

        init(state: HostFeatureState) {
            self.tableGroups = state.tableGroups
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

            GroupedTableListView(tableGroups: self.viewStore.tableGroups)
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
                    reducer: Reducer<HostFeatureState, HostFeatureAction, Void>.empty,
                    environment: ()
                )
            )
        }
    }
}

#endif
