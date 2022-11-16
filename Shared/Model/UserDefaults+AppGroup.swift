import Foundation

extension UserDefaults {
    static let appGroup = UserDefaults(suiteName: "group.kappa.expense")!
}

extension UserDefaults {
    enum Keys: String {
        case income
        case expense
    }
}
