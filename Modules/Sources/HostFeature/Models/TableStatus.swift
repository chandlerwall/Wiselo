public struct TableStatus: Equatable, Identifiable {
    public let id: String
    let tableId: String // FIXME: Remove or use Table as type. Inverse relationship needed?
    let status: Table.Status // FIXME: Use TableStatus type.
    let deleted: Bool // FIXME: Consider renaming to isDeleted.
}

extension TableStatus {
    init?(from response: TableStatusResponse) {
        // FIXME: Consider returning nil if deleted.
        guard let status = Table.Status(stringValue: response.status) else { return nil }

        self.init(
            id: String(response.id),
            tableId: String(response.table_id),
            status: status,
            deleted: response.deleted ?? false
        )
    }
}
