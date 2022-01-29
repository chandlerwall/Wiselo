struct Table: Equatable, Identifiable {
    let id: String
    let roomId: String // FIXME: Use Room type.
    let name: String
    let minCapacity: Int // FIXME: Consider Range for capacity
    let maxCapacity: Int
    let preferenceIds: Set<String> // FIXME: Use SectionPreference type.
}

// "table_id": 1,
// "room_id": 1,
// "name": "1",
// "min_capacity": 1,
// "max_capacity": 2,
// "preference_ids": [2,3]
