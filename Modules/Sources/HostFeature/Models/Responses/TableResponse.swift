struct TableResponse {
    let id: String
    let roomId: String // FIXME: Use Room type.
    let name: String
    let minCapacity: Int
    let maxCapacity: Int
    let preferenceIds: [String] // FIXME: Use SectionPreference type.
}

// "table_id": 1,
// "room_id": 1,
// "name": "1",
// "min_capacity": 1,
// "max_capacity": 2,
// "preference_ids": [2,3]
