public struct Restaurant: Equatable {
    let rooms: [Room]
    let sections: [SectionPreference]
    let tables: [Table]
    //    let statuses: [TableStatus] // FIXME: Use or remove statuses
}

typealias RestaurantResponse = (
    rooms: [RoomResponse],
    sections: [SectionPreferenceResponse],
    tables: [TableResponse],
    statuses: [TableStatusResponse]
)

extension Restaurant {
    init(from response: RestaurantResponse) {
        let rooms = response.rooms.map(Room.init(from:))
        let sections = response.sections.map(SectionPreference.init(from:))
        let tables = response.tables.map { tableResponse in
            Table(
                tableResponse: tableResponse,
                statusResponses: response.statuses.filter { $0.table_id == tableResponse.table_id }
            )
        }

        self.init(rooms: rooms, sections: sections, tables: tables)
    }
}
