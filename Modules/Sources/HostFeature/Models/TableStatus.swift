public struct TableStatus: Equatable, Identifiable {
    public let id: String
    let tableId: String
    let status: Table.Status
    let isDeleted: Bool
}

extension TableStatus {
    init?(from response: TableStatusResponse) {
        guard let status = Table.Status(stringValue: response.status) else { return nil }

        self.init(
            id: String(response.id),
            tableId: String(response.table_id),
            status: status,
            isDeleted: response.deleted ?? false
        )
    }
}
