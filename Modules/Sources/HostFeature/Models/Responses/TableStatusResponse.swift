struct TableStatusResponse: Codable {
    let id: Int
    let table_id: Int
    let status: String
    let deleted: Bool?
}
