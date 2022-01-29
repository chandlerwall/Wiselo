import SwiftUI

struct GroupedTableListView: View {
    var body: some View {
        List {
            ForEach(1...3, id: \.self) { group in
                Section {
                    ForEach(1...5, id: \.self) { table in
                        TableRowView(name: String(table))
                    }
                } header: {
                    // FIXME: Collapsible header
                    HStack {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 8)
                            .foregroundColor(.mint)

                        Text("Group \(group)") // FIXME: Introduce view for collapsible section header.

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
