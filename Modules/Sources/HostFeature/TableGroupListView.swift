import SwiftUI

struct TableGroupListView: View {

    let tableGroups: [TableGroup]

    var body: some View {
        List {
            ForEach(self.tableGroups) { group in
                Section {
                    ForEach(group.tables) { table in
                        TableRowView(table: table)
                    }
                } header: {
                    // FIXME: Collapsible header
                    TableGroupSectionHeaderView(tableGroup: group)
                }
            }
        }
        .listStyle(.plain)
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
        .frame(maxHeight: 500)
    }
}

#endif
