struct TableGroup: Equatable, Identifiable {
    let type: `Type` // FIXME: private
    let tables: [Table]

    // FIXME: var isExpanded (default to true for the first available)

    var id: String { self.type.id }
    var name: String { self.type.name }

    enum `Type`: Equatable, Identifiable {
        case firstAvailable
        case room(Room)
        case section(SectionPreference)

        var id: String {
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
    static let mockRoomMain = TableGroup(type: .room(.mockMainDining), tables: [.mockTable1, .mockTable2])
    static let mockRoomPatio = TableGroup(type: .room(.mockPatio), tables: [.mockTable8, .mockTableR1])
    static let mockSectionIndoor = TableGroup(type: .section(.mockIndoor), tables: [.mockTable1])
}

#endif
