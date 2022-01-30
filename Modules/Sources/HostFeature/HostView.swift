import ComposableArchitecture
import DesignLanguage
import SwiftUI

public struct HostView: View {

    struct ViewState: Equatable {
        let searchText: String
        let tableGroups: [TableGroup]
        let selection: String?

        init(state: HostFeatureState) {
            self.searchText = state.searchText
            self.tableGroups = state.tableGroups
            self.selection = state.selection
        }
    }

    @FocusState private var inputIsFocused: Bool // FIXME: FocusState breaks preview

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
            TextField(
                "Search Input - Number of Guests",
                text: self.viewStore.binding(get: \.searchText, send: { .setSearchText($0) }),
                prompt: Text("# of Guests")
            )
            .font(.title2)
            .keyboardType(.numberPad)
            .focused(self.$inputIsFocused)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()

                    Button(action: { self.inputIsFocused = false }) {
                        Text("Done")
                    }
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(UIColor.secondarySystemFill))
            }
            .padding()

            TableGroupListView(
                tableGroups: self.viewStore.tableGroups,
                selection: self.viewStore.selection,
                onToggleGroupExpansion: { groupId in self.viewStore.send(.toggleGroupExpansion(groupId)) },
                onSelectTable: { groupId, tableId in self.viewStore.send(.selectTable(groupId, tableId)) }
            )
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
