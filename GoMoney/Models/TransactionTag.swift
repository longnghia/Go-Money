enum TransactionTag {
    case food, rent, internet, transport, grocery, fuel, trip, insurance, medical, household, gift, beauty, education, salary, allowance, bonus, other

    static let incomeTags: [TransactionTag] = [.salary, .allowance, .bonus, .other]

    static let expenseTags: [TransactionTag] = [.food, .rent, .internet, .transport, .grocery, .fuel, .trip, .insurance, .medical, .household, .gift, .beauty, .education, .other]

    func getName() -> String {
        switch self {
        case .food: return "Food"
        case .rent: return "Rent"
        case .internet: return "Internet"
        case .transport: return "Transport"
        case .grocery: return "Grocery"
        case .fuel: return "Fuel"
        case .trip: return "Trip"
        case .insurance: return "Insurance"
        case .medical: return "Medical"
        case .household: return "Household"
        case .gift: return "Gift"
        case .beauty: return "Beauty"
        case .education: return "Education"

        case .salary: return "Salary"
        case .allowance: return "Allowance"
        case .bonus: return "Bonus"

        case .other: return "Other"
        }
    }

    func getIcon() -> String {
        switch self {
        case .food: return "trans_type_food"
        case .rent: return "trans_type_rent"
        case .internet: return "trans_type_internet"
        case .transport: return "trans_type_transport"
        case .grocery: return "trans_type_grocery"
        case .fuel: return "trans_type_fuel"
        case .trip: return "trans_type_trip"
        case .insurance: return "trans_type_insurance"
        case .medical: return "trans_type_medical"
        case .household: return "trans_type_household"
        case .gift: return "trans_type_gift"
        case .beauty: return "trans_type_beauty"
        case .education: return "trans_type_education"

        case .salary: return "trans_type_salary"
        case .allowance: return "trans_type_allowance"
        case .bonus: return "trans_type_bonus"

        case .other: return "trans_type_other"
        }
    }
}
