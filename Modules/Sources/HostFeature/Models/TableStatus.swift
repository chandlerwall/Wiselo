public struct TableStatus: Identifiable, Equatable {
    public let id: String
    let tableId: String // FIXME: Remove or use Table as type. Inverse relationship needed?
    let status: String // FIXME: Use TableStatus type.
    let deleted: Bool // FIXME: Consider renaming to isDeleted.
}

// "id": 1,
// "table_id": 1,
// "status": "dirty",
// "deleted": true
