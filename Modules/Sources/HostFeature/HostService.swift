import ComposableArchitecture
import Core

public struct HostService {

    public init() { }

    func rooms() -> Effect<[RoomResponse], APIError> {
        Effect.future { callback in
            guard
                let url = Bundle.module.url(forResource: "rooms", withExtension: "json"),
                let data = try? Data(contentsOf: url)
            else {
                callback(.failure(.response))
                return
            }

            guard let rooms = try? JSONDecoder().decode([RoomResponse].self, from: data)
            else {
                callback(.failure(.decode))
                return
            }

            callback(.success(rooms))
        }
    }

    func sectionPreferences() -> Effect<[SectionPreferenceResponse], APIError> {
        Effect.future { callback in
            guard
                let url = Bundle.module.url(forResource: "section_preferences", withExtension: "json"),
                let data = try? Data(contentsOf: url)
            else {
                callback(.failure(.response))
                return
            }

            guard let preferences = try? JSONDecoder().decode([SectionPreferenceResponse].self, from: data)
            else {
                callback(.failure(.decode))
                return
            }

            callback(.success(preferences))
        }
    }

    func tables() -> Effect<[TableResponse], APIError> {
        Effect.future { callback in
            guard
                let url = Bundle.module.url(forResource: "tables", withExtension: "json"),
                let data = try? Data(contentsOf: url)
            else {
                callback(.failure(.response))
                return
            }

            guard let tables = try? JSONDecoder().decode([TableResponse].self, from: data)
            else {
                callback(.failure(.decode))
                return
            }

            callback(.success(tables))
        }
    }

    func tableStatuses() -> Effect<[TableStatusResponse], APIError> {
        Effect.future { callback in
            guard
                let url = Bundle.module.url(forResource: "table_status", withExtension: "json"),
                let data = try? Data(contentsOf: url)
            else {
                callback(.failure(.response))
                return
            }

            guard let statuses = try? JSONDecoder().decode([TableStatusResponse].self, from: data)
            else {
                callback(.failure(.decode))
                return
            }

            callback(.success(statuses))
        }
    }
}
