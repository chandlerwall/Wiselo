struct Table: Equatable, Identifiable {
    let id: String
    let roomId: String // FIXME: Use Room type.
    let preferenceIds: Set<String> // FIXME: Use SectionPreference type.
    let name: String
    var status: Status
    let minCapacity: Int // FIXME: Consider Range for capacity
    let maxCapacity: Int

    enum Status: Equatable {
        case open
        case seated
        case dirty
        case closed
    }
}

extension Table {
    init(from response: TableResponse) {
        self.init(
            id: String(response.table_id),
            roomId: String(response.room_id),
            preferenceIds: Set(response.preference_ids.map(String.init)),
            name: response.name,
            status: .open,
            minCapacity: response.min_capacity,
            maxCapacity: response.max_capacity
        )
    }

    init(tableResponse: TableResponse, statusResponses: [TableStatusResponse]) {
        let status = statusResponses.compactMap(TableStatus.init(from:)).filter { !$0.deleted }.last?.status
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
