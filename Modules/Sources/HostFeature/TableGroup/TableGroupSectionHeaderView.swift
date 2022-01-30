import SwiftUI

struct TableGroupSectionHeaderView: View {

    let tableGroup: TableGroup

    var body: some View {
        let count = self.tableGroup.tables.count

        HStack {
            Image(systemName: "circle.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 8)
                .foregroundColor(self.color) // FIXME: Deterministic color based on type

            Text(self.tableGroup.name) // FIXME: Introduce view for collapsible section header.
                .foregroundColor(.secondary)
                .font(.headline)

            Spacer()

            // FIXME: If no options available, show wait time.
            if count > 0 {
                Text("\(count) \(count == 1 ? "option" : "options")") // FIXME: Ensure that count accurately reflects filter criteria.
                    .foregroundColor(.green)
            } else {
                VStack(alignment: .trailing) {
                    Text("Est. Wait: N/A")
                        .font(.callout)

                    Text("0 tables")
                        .font(.caption)
                }
                .foregroundColor(.red)
            }

            Image(systemName: "chevron.down") // FIXME: Dynamic icon based on collapse state
                .resizable()
                .scaledToFit()
                .frame(width: 10)
                .foregroundColor(.primary) // FIXME: dynamic color (based on status)
        }
    }

    private var color: Color {
        switch self.tableGroup.type {
        case .firstAvailable:
            return .purple

        case .room(_):
            return .mint

        case .section(_):
            return .orange
        }
    }
}

#if DEBUG

import PreviewHelpers

struct TableGroupSectionHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Preview { TableGroupSectionHeaderView(tableGroup: .mockFirstAvailable) }
            Preview { TableGroupSectionHeaderView(tableGroup: .init(type: .firstAvailable, tables: [])) }
            Preview { TableGroupSectionHeaderView(tableGroup: .mockRoomMain) }
            Preview { TableGroupSectionHeaderView(tableGroup: .mockSectionIndoor) }
        }
    }
}

#endif
