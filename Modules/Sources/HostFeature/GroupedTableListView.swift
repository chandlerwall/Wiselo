import SwiftUI

struct GroupedTableListView: View {

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
                    HStack {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 8)
                            .foregroundColor(.mint)

                        Text(group.name) // FIXME: Introduce view for collapsible section header.

                        Spacer()

                        // FIXME: If no options available, show wait time.
                        Text("\(73) options")

                        Image(systemName: "chevron.down") // FIXME: Dynamic icon based on collapse state
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10)
                            .foregroundColor(.primary) // FIXME: dynamic color (based on status)
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}

//#if DEBUG
//
//import PreviewHelpers
//
//struct GroupedTableListView_Previews: PreviewProvider {
//    static var previews: some View {
//        Preview {
//            GroupedTableListView()
//        }
//        .frame(maxHeight: 400)
//    }
//}
//
//#endif
