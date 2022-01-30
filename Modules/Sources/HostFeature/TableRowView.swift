import SwiftUI

struct TableRowView: View {

    let table: Table

    var body: some View {
        HStack {
            (
                Text(self.table.name)
                    .font(.headline)

                + Text(" - Host Name")
            )
            .foregroundColor(.secondary)

            Spacer()

            Label(
                "\(self.table.minCapacity)-\(self.table.maxCapacity)",
                systemImage: "person.2"
            )
            .foregroundColor(.primary)
            .font(.headline.monospacedDigit())
        }
    }
}

#if DEBUG

import PreviewHelpers

struct TableRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Preview { TableRowView(table: .mockTable1) }.frame(maxWidth: 250)
            Preview { TableRowView(table: .mockTable2) }.frame(maxWidth: 300)
            Preview { TableRowView(table: .mockTable8) }.frame(maxWidth: 350)
            Preview { TableRowView(table: .mockTableR1) }.frame(maxWidth: 350)
        }
    }
}

#endif
