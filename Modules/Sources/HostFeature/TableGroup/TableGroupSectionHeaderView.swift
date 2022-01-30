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
                .foregroundColor(self.color)

            Text(self.tableGroup.name)
                .foregroundColor(.secondary)
                .font(.headline)

            Spacer()

            if count > 0 {
                Text("\(count) \(count == 1 ? "option" : "options")")
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

            Image(systemName: "chevron.down")
                .resizable()
                .scaledToFit()
                .frame(width: 10)
                .rotationEffect(self.tableGroup.isExpanded ? .degrees(180) : .zero)
                .foregroundColor(.primary)
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
