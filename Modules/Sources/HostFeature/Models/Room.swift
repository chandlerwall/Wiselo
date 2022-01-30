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

#if DEBUG

extension Room {
    static let mockMainDining = Room(id: "1", name: "Main Dining Room")
    static let mockPatio = Room(id: "2", name: "Patio")
    static let mockRooftop = Room(id: "3", name: "Rooftop Lounge")
}

extension Array where Element == Room {
    static let mock: Self = [.mockMainDining, .mockPatio, .mockRooftop]
}

#endif
