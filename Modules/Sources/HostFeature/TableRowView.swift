import SwiftUI

struct TableRowView: View {

    let table: Table

    var body: some View {
        HStack {
            Text(self.table.name)

            Text("- Host Name")

            Spacer()

            Image(systemName: "person.2")

            Text("2-4")
        }
    }
}

//#if DEBUG
//
//import PreviewHelpers
//
//struct TableRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        Preview {
//            TableRowView(
//                name: "Table Name"
//            )
//        }
//    }
//}
//
//#endif
