import ComposableArchitecture
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

    let store: Store<HostFeatureState, HostFeatureAction>
    @ObservedObject var viewStore: ViewStore<ViewState, HostFeatureAction>

    public init(
        store: Store<HostFeatureState, HostFeatureAction>
    ) {
        self.store = store
        self.viewStore = ViewStore(self.store.scope(state: ViewState.init(state:)))
    }

    @FocusState private var inputIsFocused: Bool

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
                            .font(.subheadline)
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
            // NOTE: ToolbarItemGroup(placement: .keyboard) is unreliable.
            // - To prevent the number pad keyboard from becoming stuck, the focus is explicitly cleared during scroll-like gestures.
            // - When the toolbar is working, a "Done" button appears above the number pad (to dismiss the keyboard).
            .gesture(DragGesture().onChanged { _ in self.inputIsFocused = false })
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}

#if DEBUG

import PreviewHelpers

struct HostView_Previews: PreviewProvider {
    static var previews: some View {
        DevicePreview {
            // NOTE: The presence of `@FocusState` breaks Xcode previews.
            // - `HostView` must be wrapped with a ZStack to avoid preview crashes during updates.
            // - This is an Xcode issue and does not impact `HostView` at runtime (simulator or hardware).
            ZStack {
                HostView(
                    store: Store(
                        initialState: .mock,
                        reducer: hostReducer,
                        environment: ()
                    )
                )
            }
        }
    }
}

#endif
