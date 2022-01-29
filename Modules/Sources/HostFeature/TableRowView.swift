import SwiftUI

struct TableRowView: View {
    var body: some View {
        Text("Table")
    }
}

#if DEBUG

import PreviewHelpers

struct TableRowView_Previews: PreviewProvider {
    static var previews: some View {
        Preview {
            TableRowView()
        }
    }
}

#endif
