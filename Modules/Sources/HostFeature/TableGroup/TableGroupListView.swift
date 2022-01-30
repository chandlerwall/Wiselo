import SwiftUI

struct TableGroupListView: View {

    let tableGroups: [TableGroup]

    var body: some View {
        List {
            ForEach(self.tableGroups) { group in
                Section {
                    if group.isExpanded {
                        ForEach(group.tables) { table in
                            TableRowView(table: table)
                                .padding(.horizontal)
                                .padding(.bottom)
                                .listRowInsets(.zero)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                        }
                    }
                } header: {
                    // FIXME: Collapsible header
                    TableGroupSectionHeaderView(tableGroup: group)
                        .padding(.horizontal)
                        .listRowInsets(.zero)
                }
                .listSectionSeparator(.visible, edges: .bottom)
                .textCase(nil)
            }
        }
        .listStyle(.grouped)
    }
}

#if DEBUG

import PreviewHelpers

struct GroupedTableListView_Previews: PreviewProvider {
    static var previews: some View {
        Preview {
            TableGroupListView(
                tableGroups: [
                    .mockFirstAvailable,
                    .mockRoomMain,
                    .mockRoomPatio,
                    .mockSectionIndoor
                ]
            )
        }
        .frame(maxHeight: 600)
    }
}

#endif
