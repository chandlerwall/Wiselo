public struct TableGroup: Equatable, Identifiable {

    public init(
        type: `Type`,
        tables: [Table]
    ) {
        self.type = type
        self.tables = tables
        self.isExpanded = type == .firstAvailable || tables.count == 1
    }

    let type: `Type`

    public var id: String { self.type.id }
    var name: String { self.type.name }
    let tables: [Table]
    var isExpanded: Bool

    public enum `Type`: Equatable, Identifiable {
        case firstAvailable
        case room(Room)
        case section(SectionPreference)

        public var id: String {
            switch self {
            case .firstAvailable:
                return "firstAvailable"

            case let .room(room):
                return "room" + room.id

            case let .section(section):
                return "section" + section.id
            }
        }

        var name: String {
            switch self {
            case .firstAvailable:
                return "First Available"

            case let .room(room):
                return room.name

            case let .section(section):
                return section.name
            }
        }
    }
}

#if DEBUG

extension TableGroup {
    static let mockFirstAvailable = TableGroup(type: .firstAvailable, tables: [.mockTable1])
    static let mockRoomMain = TableGroup(type: .room(.mockMainDining), tables: [.mockTable1, .mockTable2, .mockTable9])
    static let mockRoomPatio = TableGroup(type: .room(.mockPatio), tables: [.mockTable8, .mockTableR1])
    static let mockSectionIndoor = TableGroup(type: .section(.mockIndoor), tables: [.mockTable1])
}

#endif
