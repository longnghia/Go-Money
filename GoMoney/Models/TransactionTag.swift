import RealmSwift

class TransactionTag: Object, Codable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var icon: String
    @Persisted var type: String

    convenience init(name: String, icon: String, type: ExpenseType) {
        self.init()
        self.name = name
        self.icon = icon
        self.type = type.rawValue
    }

    enum CodingKeys: String, CodingKey {
        case _id
        case name
        case icon
        case type
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_id, forKey: ._id)
        try container.encode(name, forKey: .name)
        try container.encode(icon, forKey: .icon)
        try container.encode(type, forKey: .type)
    }
}

extension TransactionTag {
    static let defaults: [TransactionTag] = [
        TransactionTag(name: "Food", icon: "trans_type_food", type: .expense),
        TransactionTag(name: "Rent", icon: "trans_type_rent", type: .expense),
        TransactionTag(name: "Internet", icon: "trans_type_internet", type: .expense),
        TransactionTag(name: "Transport", icon: "trans_type_transport", type: .expense),
        TransactionTag(name: "Grocery", icon: "trans_type_grocery", type: .expense),
        TransactionTag(name: "Fuel", icon: "trans_type_fuel", type: .expense),
        TransactionTag(name: "Trip", icon: "trans_type_trip", type: .expense),
        TransactionTag(name: "Grocery", icon: "trans_type_grocery", type: .expense),
        TransactionTag(name: "Insurance", icon: "trans_type_insurance", type: .expense),
        TransactionTag(name: "Medical", icon: "trans_type_medical", type: .expense),
        TransactionTag(name: "Household", icon: "trans_type_household", type: .expense),
        TransactionTag(name: "Gift", icon: "trans_type_gift", type: .expense),
        TransactionTag(name: "Beauty", icon: "trans_type_beauty", type: .expense),
        TransactionTag(name: "Education", icon: "trans_type_education", type: .expense),
        TransactionTag(name: "Other", icon: "trans_type_other", type: .expense),

        TransactionTag(name: "Salary", icon: "trans_type_salary", type: .income),
        TransactionTag(name: "Allowance", icon: "trans_type_allowance", type: .income),
        TransactionTag(name: "Bonus", icon: "trans_type_bonus", type: .income),
        TransactionTag(name: "Other", icon: "trans_type_other", type: .income),
    ]
}
