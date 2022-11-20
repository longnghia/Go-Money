enum MoneyFormatter {
    static func formatShorter(amount: Double, currency: CurrencyUnit) -> String {
        switch currency {
        case .dong:
            switch amount {
            case 1 ..< 1_000_000:
                return amount.formatWithCommas()
            default:
                let million = amount / 1_000_000
                let formated = million.formatWithCommas(minFraction: 2, maxFraction: 2)
                return "\(formated)tr"
            }

        default:
            return String(amount.formatWithCommas())
        }
    }
}
