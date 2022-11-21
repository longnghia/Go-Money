import Foundation

extension Double {
    func formatWithCommas(minFraction: Int = 0, maxFraction: Int = 0) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.minimumFractionDigits = minFraction
        numberFormatter.maximumFractionDigits = maxFraction
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.locale = Locale.current
        numberFormatter.currencySymbol = ""

        if let formattedNumber = numberFormatter.string(from: NSNumber(value: self)) {
            return formattedNumber
        } else {
            return String(self)
        }
    }
}
