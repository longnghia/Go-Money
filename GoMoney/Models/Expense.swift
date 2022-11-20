import RealmSwift
import UIKit

class Expense: Object, Codable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var type: String
    @Persisted var tag: TransactionTag?
    @Persisted var amount: Double
    @Persisted var note: String
    @Persisted var occuredOn: Date
    @Persisted var createdAt: Date?
    @Persisted var updatedAt: Date?

    convenience init(type: ExpenseType = .expense, tag: TransactionTag, amount: Double, note: String = "", occuredOn: Date, createdAt: Date? = Date(), updatedAt: Date? = nil) {
        self.init()
        self.type = type.rawValue
        self.tag = tag
        self.amount = amount
        self.note = note
        self.occuredOn = occuredOn
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    enum CodingKeys: String, CodingKey {
        case _id
        case type
        case tag
        case amount
        case note
        case occuredOn
        case createdAt
        case updatedAt
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_id, forKey: ._id)
        try container.encode(type, forKey: .type)
        try container.encode(tag?._id.stringValue, forKey: .tag)
        try container.encode(amount, forKey: .amount)
        try container.encode(note, forKey: .note)
        try container.encode(occuredOn, forKey: .occuredOn)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
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

/// Transaction structure on firestore.
struct RemoteTransaction: Codable {
    var _id: String
    var type: String
    var tag: String
    var amount: Double
    var note: String
    var occuredOn: Date
    var createdAt: Date?
    var updatedAt: Date?
}
