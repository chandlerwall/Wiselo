public struct TableStatus: Identifiable, Equatable {
    public let id: String
    let tableId: String // FIXME: Remove or use Table as type. Inverse relationship needed?
    let status: String // FIXME: Use TableStatus type.
    let deleted: Bool // FIXME: Consider renaming to isDeleted.
}

extension TableStatus {
    init(from response: TableStatusResponse) {
        self.init(
            id: String(response.id),
            tableId: String(response.table_id),
            status: response.status,
            deleted: response.deleted ?? false
        )
    }
}
