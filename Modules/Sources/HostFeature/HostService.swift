import ComposableArchitecture
import Core

public struct HostService {
    public let rooms: () -> Effect<[RoomResponse], APIError>
    public let sectionPreferences: () -> Effect<[SectionPreferenceResponse], APIError>
    public let tables: () -> Effect<[TableResponse], APIError>
    public let tableStatuses: () -> Effect<[TableStatusResponse], APIError>
}

extension HostService {
    // FIXME: Load data from persistent storage and/or initialize from embedded resource file.
    public static let live: Self = .init(
        rooms: { Effect(value: []) },
        sectionPreferences: { Effect(value: []) },
        tables: { Effect(value: []) },
        tableStatuses: { Effect(value: []) }
    )
}

#if DEBUG

extension HostEnvironment {
    // FIXME: Include mock values once available.
    public static let mock: Self = .init(
        rooms: { Effect(value: []) },
        sectionPreferences: { Effect(value: []) },
        tables: { Effect(value: []) },
        tableStatuses: { Effect(value: []) }
    )
}

#endif
