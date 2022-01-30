import SwiftUI

struct TableGroupListView: View {

    let tableGroups: [TableGroup]
    let selection: String?

    let onToggleGroupExpansion: (TableGroup.ID) -> Void
    let onSelectTable: (TableGroup.ID, Table.ID) -> Void

    var body: some View {
        List {
            ForEach(self.tableGroups) { group in
                Section {
                    if group.isExpanded {
                        ForEach(group.tables) { table in
                            Button(action: { self.onSelectTable(group.id, table.id) }) {
                                TableRowView(
                                    table: table,
                                    isSelected: self.selection == "\(group.id)\(table.id)"
                                )
                                .padding(.horizontal)
                                .padding(.bottom)
//                                .contentShape(Rectangle())
                            }
                            .listRowInsets(.zero)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                    }
                } header: {
                    Button(action: { self.onToggleGroupExpansion(group.id) }) {
                        TableGroupSectionHeaderView(tableGroup: group)
                            .padding(.horizontal)
                            .contentShape(Rectangle())
                    }
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
                ],
                selection: nil,
                onToggleGroupExpansion: { _ in },
                onSelectTable: { _, _ in }
            )
        }
        .frame(maxHeight: 600)
    }
}

#endif
