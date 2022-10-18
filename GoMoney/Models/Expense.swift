import UIKit

struct Expense {
    var id: String
    var createdAt: Date?
    var occuredOn: Date
    var type: String?
    var title: String?
    var note: String?
    var amount: Double
}

extension Expense {
    static let mock: [Expense] = [
        Expense(id: "0", occuredOn: Date(), title: "Expense 0", amount: 100),
        Expense(id: "1", occuredOn: Date(), title: "Expense 1", amount: 110),
        Expense(id: "2", occuredOn: Date(), title: "Expense 2", amount: 120),
        Expense(id: "3", occuredOn: Date(), title: "Expense 3", amount: 130),
        Expense(id: "4", occuredOn: Date(), title: "Expense 4", amount: 140),
        Expense(id: "5", occuredOn: Date(), title: "Expense 5", amount: 150),
        Expense(id: "6", occuredOn: Date(), title: "Expense 6", amount: 160),
        Expense(id: "7", occuredOn: Date(), title: "Expense75", amount: 7150),
        Expense(id: "8", occuredOn: Date(), title: "Expense 8", amount: 180),
        Expense(id: "9", occuredOn: Date(), title: "Expense 9", amount: 190),
        Expense(id: "10", occuredOn: Date(), title: "Expense 10", amount: 1100),
        Expense(id: "11", occuredOn: Date(), title: "Expense 11", amount: 1100),
        Expense(id: "12", occuredOn: Date(), title: "Expense 12", amount: 11200)
    ]
}
