import Combine
import ComposableArchitecture
import Core

public struct HostFeatureState: Equatable {

    public init(
        restaurant: Restaurant,
        searchText: String = ""
    ) {
        self.init(
            rooms: restaurant.rooms,
            sections: restaurant.sections,
            tables: restaurant.tables,
            searchText: searchText
        )
    }

    public init(
        rooms: [Room] = [],
        sections: [SectionPreference] = [],
        tables: [Table] = [],
        searchText: String = ""
    ) {
        self.rooms = rooms
        self.sections = sections
        self.tables = tables
        self.searchText = searchText

        self.filterTableGroups()
    }

    var rooms: [Room]
    var sections: [SectionPreference] // FIXME: maybe rename to include preferences in name
    var tables: [Table]
    var selection: String?
    private(set) var tableGroups: [TableGroup] = []

    var searchText: String

    fileprivate mutating func filterTableGroups() {
        self.selection = nil
        self.tableGroups = self._tableGroups
    }

    fileprivate mutating func toggleTableGroupExpansion(_ groupId: TableGroup.ID) {
        guard let index = self.tableGroups.firstIndex(where: { $0.id == groupId })
        else { return }

        self.tableGroups[index].isExpanded.toggle()
    }

    private var _tableGroups: [TableGroup] {
        [self.firstAvailable] + self.tablesByRoom + self.tablesBySection
    }

    private var validTables: [Table] {
        let partySize = Int(self.searchText) ?? 0
        return partySize > 0
            ? self.tables.filter { partySize >= $0.minCapacity && partySize <= $0.maxCapacity }
            : self.tables
    }

    private var firstAvailable: TableGroup {
        return TableGroup(
            type: .firstAvailable,
            tables: Array(self.validTables.suggested.prefix(3))
        )
    }

    private var tablesByRoom: [TableGroup] {
        self.rooms.sorted(on: \.name).map { room in
            TableGroup(
                type: .room(room),
                tables: self.validTables.filter { $0.roomId == room.id }.suggested
            )
        }
    }

    private var tablesBySection: [TableGroup] {
        self.sections.sorted(on: \.name).map { section in
            TableGroup(
                type: .section(section),
                tables: self.validTables.filter { $0.preferenceIds.contains(section.id) }.suggested
            )
        }
    }
}

public enum HostFeatureAction: Equatable {
    case setSearchText(String)
    case toggleGroupExpansion(TableGroup.ID)
    case selectTable(TableGroup.ID, Table.ID)
    case didReceiveTableStatus(TableStatus)
}

public typealias HostEnvironment = Void

public let hostReducer: Reducer<HostFeatureState, HostFeatureAction, Void> = Reducer
{ state, action, _ in
    switch action {
    case let .setSearchText(searchText):
        // FIXME: Document improvement; Only allow digits.
        state.searchText = searchText
        state.filterTableGroups()
        return .none

    case let .toggleGroupExpansion(groupId):
        state.toggleTableGroupExpansion(groupId)
        return .none

    case let .selectTable(groupId, tableId):
        let selectionId = groupId + tableId
        state.selection = selectionId == state.selection ? nil : selectionId // FIXME: Document; clear selection on second tap
        return .none

    case .didReceiveTableStatus(_):
        // FIXME: Document
        return .none
    }
}

#if DEBUG

extension HostFeatureState {
    static let mock = HostFeatureState(
        rooms: .mock,
        sections: .mock,
        tables: .mock,
        searchText: "3"
    )
}

#endif
