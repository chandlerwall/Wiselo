public struct Room: Equatable, Identifiable {
    public let id: String
    public let name: String
}

extension Room {
    init(from response: RoomResponse) {
        self.init(
            id: response.room_id,
            name: response.room_name
        )
    }
}
