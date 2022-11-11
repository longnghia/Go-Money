import Foundation

extension UserDefaults {
    static let appGroup = UserDefaults(suiteName: "group.ln.gomoney")!
}

extension UserDefaults {
    enum Keys: String {
        case income
        case expense
    }
}
