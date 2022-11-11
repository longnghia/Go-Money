enum SyncInterval: Int {
    case min1 = 60
    case min5 = 300
    case min30 = 1800
    case hour1 = 3600

    static let all: [SyncInterval] = [.min1, .min5, .min30, .hour1]

    func getTitle() -> String {
        switch self {
        case .min1: return "In 1 minute"
        case .min5: return "In 5 minutes"
        case .min30: return "In 30 minutes"
        case .hour1: return "In One hour"
        }
    }
}
