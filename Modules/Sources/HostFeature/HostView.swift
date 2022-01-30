import ComposableArchitecture
import DesignLanguage
import SwiftUI

public struct HostView: View {

    struct ViewState: Equatable {
        let searchText: String
        let tableGroups: [TableGroup]

        init(state: HostFeatureState) {
            self.searchText = state.searchText
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
                text: self.viewStore.binding(get: \.searchText, send: { .setSearchText($0) })
            )
            .keyboardType(.numberPad)
            .padding()

            TableGroupListView(tableGroups: self.viewStore.tableGroups)
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}

#if DEBUG

import PreviewHelpers

struct HostView_Previews: PreviewProvider {
    static var previews: some View {
        DevicePreview {
            HostView(
                store: Store(
                    initialState: .mock,
                    reducer: Reducer<HostFeatureState, HostFeatureAction, Void>.empty,
                    environment: ()
                )
            )
        }
    }
}

#endif
