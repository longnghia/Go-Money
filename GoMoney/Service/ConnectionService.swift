import Reachability

class ConnectionService {
    static let shared = ConnectionService()

    var connection: Reachability.Connection?

    var isReachable: Bool {
        // TODO: check if setting only wifi
        return connection == .wifi ||
            connection == .cellular
    }
}
