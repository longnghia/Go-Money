import RealmSwift
import UIKit

class Expense: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var type: String?
    @Persisted var title: String?
    @Persisted var tag: String?
    @Persisted var amount: Double
    @Persisted var note: String?
    @Persisted var occuredOn: Date
    @Persisted var createdAt: Date?
    @Persisted var updatedAt: Date?

    convenience init(type: ExpenseType = .expense, title: String? = nil, tag: String? = nil, amount: Double, note: String? = nil, occuredOn: Date, createdAt: Date? = Date(), updatedAt: Date? = nil) {
        self.init()
        self.type = type.rawValue
        self.title = title
        self.tag = tag
        self.amount = amount
        self.note = note
        self.occuredOn = occuredOn
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

enum ExpenseType: String {
    case income, expense
}

enum ExpenseSort: String {
    case createdAt
    case updatedAt
    case occuredOn
}

enum ExpenseFilter {
    case all
    case week
    case month
}

extension Expense {
    enum ExpenseDateType {
        case occured, created, updated
    }

    func getDate(_ type: ExpenseDateType = .occured, formatter: DateFormatter = DateFormatter.ddmmyyyy) -> String {
        var date: Date?
        switch type {
        case .created:
            date = createdAt
        case .updated:
            date = updatedAt
        case .occured:
            date = occuredOn
        }
        return formatter.string(from: date ?? Date())
    }
}
