enum StartupStatus: Equatable {
    case uninitialized
    case initializing
    case restoring
    case refreshing
    case preparing
    case done
    case error(message: String)
}
