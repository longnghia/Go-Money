import RealmSwift
import UIKit

class Expense: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var type: String
    @Persisted var title: String
    @Persisted var tag: String
    @Persisted var amount: Double
    @Persisted var note: String?
    @Persisted var occuredOn: Date
    @Persisted var createdAt: Date?
    @Persisted var updatedAt: Date?

    convenience init(type: ExpenseType = .expense, title: String = "Expense \(DateFormatter.today)", tag: TransactionTag = .food, amount: Double, note: String? = nil, occuredOn: Date, createdAt: Date? = Date(), updatedAt: Date? = nil) {
        self.init()
        self.type = type.rawValue
        self.title = title
        self.tag = tag.getName()
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
    case year

    static let allFilters: [ExpenseFilter] = [.week, .month, .year, .all]

    func getName() -> String {
        switch self {
        case .all:
            return "All"
        case .week:
            return "This Week"
        case .month:
            return "This Month"
        case .year:
            return "This Year"
        }
    }
}

struct TagAmount {
    let tag: String
    var totalAmount: Double
}

struct DateAmount {
    let date: Date
    var totalAmount: Double
}
