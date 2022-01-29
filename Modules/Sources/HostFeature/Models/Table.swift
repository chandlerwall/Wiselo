struct Table: Equatable, Identifiable {
    let id: String
    let roomId: String // FIXME: Use Room type.
    let name: String
    let minCapacity: Int // FIXME: Consider Range for capacity
    let maxCapacity: Int
    let preferenceIds: Set<String> // FIXME: Use SectionPreference type.
}

extension Table {
    init(from response: TableResponse) {
        self.init(
            id: String(response.table_id),
            roomId: String(response.room_id),
            name: response.name,
            minCapacity: response.min_capacity,
            maxCapacity: response.max_capacity,
            preferenceIds: Set(response.preference_ids.map(String.init))
        )
    }
}
