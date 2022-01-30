public struct Table: Equatable, Identifiable {
    public let id: String
    let roomId: String
    let preferenceIds: Set<String>
    let name: String
    var status: Status
    let minCapacity: Int
    let maxCapacity: Int

    enum Status: Equatable {
        case open
        case dirty
        case seated
        case closed

        var isAvailable: Bool {
            switch self {
            case .open, .dirty:
                return true
            case .seated, .closed:
                return false
            }
        }

        var priority: Int {
            switch self {
            case .open:
                return 1
            case .dirty:
                return 2
            case .seated:
                return 3
            case .closed:
                return 4
            }
        }
    }

    static func suggestedTablesSort(lhs: Self, rhs: Self) -> Bool {
        (lhs.status.priority, lhs.maxCapacity, lhs.minCapacity, lhs.name) < (rhs.status.priority, rhs.maxCapacity, rhs.minCapacity, rhs.name)
    }
}

extension Table {
    init(tableResponse: TableResponse, statusResponses: [TableStatusResponse]) {
        let status = statusResponses.compactMap(TableStatus.init(from:)).filter { !$0.isDeleted }.last?.status
        self.init(
            id: String(tableResponse.table_id),
            roomId: String(tableResponse.room_id),
            preferenceIds: Set(tableResponse.preference_ids.map(String.init)),
            name: tableResponse.name,
            status: status ?? .open,
            minCapacity: tableResponse.min_capacity,
            maxCapacity: tableResponse.max_capacity
        )
    }
}

extension Table.Status {
    init?(stringValue: String) {
        switch stringValue.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
        case "closed":
            self = .closed
        case "dirty":
            self = .dirty
        case "open":
            self = .open
        case "seated":
            self = .seated

        default:
            return nil
        }
    }
}

extension Array where Element == Table {
    // FIXME: Document; consider renaming to suggestions or topSuggested
    var suggested: Self {
        self.filter(\.status.isAvailable)
            .sorted(by: Table.suggestedTablesSort(lhs:rhs:))
    }
}

#if DEBUG

extension Table {
    static let mockTable1 = Table(
        id: "1",
        roomId: "1",
        preferenceIds: ["2", "3"],
        name: "1",
        status: .seated,
        minCapacity: 1,
        maxCapacity: 2
    )

    static let mockTable2 = Table(
        id: "2",
        roomId: "1",
        preferenceIds: ["2", "3"],
        name: "2",
        status: .seated,
        minCapacity: 1,
        maxCapacity: 1
    )

    static let mockTable8 = Table(
        id: "8",
        roomId: "1",
        preferenceIds: ["3"],
        name: "8",
        status: .open,
        minCapacity: 6,
        maxCapacity: 10
    )

    static let mockTable9 = Table(
        id: "9",
        roomId: "1",
        preferenceIds: ["2", "3"],
        name: "9",
        status: .dirty,
        minCapacity: 1,
        maxCapacity: 1
    )

    static let mockTableR1 = Table(
        id: "21",
        roomId: "3",
        preferenceIds: ["4"],
        name: "R1",
        status: .seated,
        minCapacity: 5,
        maxCapacity: 10
    )
}

extension Array where Element == Table {
    static let mock: Self = [.mockTable1, .mockTable2, .mockTable8, .mockTable9, .mockTableR1]
}

#endif
