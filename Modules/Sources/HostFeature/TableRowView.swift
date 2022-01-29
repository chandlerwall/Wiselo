import SwiftUI

struct TableRowView: View {

    let name: String // FIXME: Consider Table as type once available.

    var body: some View {
        HStack {
            Text(self.name)

            Text("- Host Name")

            Spacer()

            Image(systemName: "person.2")

            Text("2-4")
        }
    }
}

#if DEBUG

import PreviewHelpers

struct TableRowView_Previews: PreviewProvider {
    static var previews: some View {
        Preview {
            TableRowView(
                name: "Table Name"
            )
        }
    }
}

#endif
