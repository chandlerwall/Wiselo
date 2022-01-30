public struct TableResponse: Codable {
    let table_id: Int
    let room_id: Int
    let name: String
    let min_capacity: Int
    let max_capacity: Int
    let preference_ids: [Int]
}
