import SwiftUI

struct TableRowView: View {

    let table: Table
    let isSelected: Bool

    var body: some View {
        HStack {
            Group {
                Text(self.table.name)
                    .font(.headline)

                if self.table.status == .dirty {
                    Image(systemName: "tornado")
                        .font(.caption)
                }
            }
            .foregroundColor(self.isSelected ? .primary : .secondary)

            Spacer()

            Label(
                "\(self.table.minCapacity)-\(self.table.maxCapacity)",
                systemImage: "person.2"
            )
            .foregroundColor(.primary)
            .font(.headline.monospacedDigit())
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(self.isSelected ? Color.blue.opacity(0.6) : Color(UIColor.secondarySystemFill))
        }
    }
}

#if DEBUG

import PreviewHelpers

struct TableRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Preview { TableRowView(table: .mockTable1, isSelected: false) }.frame(maxWidth: 250)
            Preview { TableRowView(table: .mockTable2, isSelected: false) }.frame(maxWidth: 300)
            Preview { TableRowView(table: .mockTable8, isSelected: false) }.frame(maxWidth: 350)
            Preview { TableRowView(table: .mockTableR1, isSelected: true) }.frame(maxWidth: 350)
        }
        .padding()
    }
}

#endif
