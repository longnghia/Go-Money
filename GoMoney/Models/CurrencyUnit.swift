enum CurrencyUnit: String {
    case dollar = "$"
    case dong = "₫"
    case rupee = "₹"
    case euro = "€"
    case yen = "¥"
    case pound = "£"
    case cent = "¢"
    case kip = "₭"

    static let all: [CurrencyUnit] = [.dollar, .dong, .rupee, .euro, .yen, .pound, .cent, .kip]
}
