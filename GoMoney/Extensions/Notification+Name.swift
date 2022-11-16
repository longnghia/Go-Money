import Foundation

extension Notification.Name {
    static var loginSuccess: Notification.Name {
        return .init(rawValue: "UserLogin.success")
    }

    static let dataChanged = Notification.Name(rawValue: "com.kappa.expense.expense.changed")
}
