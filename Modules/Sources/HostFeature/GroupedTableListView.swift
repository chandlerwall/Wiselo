import SwiftUI

struct GroupedTableListView: View {
    var body: some View {
        List {
            ForEach(1...3, id: \.self) { group in
                Section {
                    ForEach(1...5, id: \.self) { table in
                        Text("Table \(table)")
                    }
                } header: {
                    Text("Group \(group)")
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
            GroupedTableListView()
        }
        .frame(maxHeight: 400)
    }
}

#endif
