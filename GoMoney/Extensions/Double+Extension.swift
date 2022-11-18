import Foundation

extension Double {
    func formatWithCommas(minFraction: Int = 0, maxFraction: Int = 0) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = minFraction
        numberFormatter.maximumFractionDigits = maxFraction
        if let formattedNumber = numberFormatter.string(from: NSNumber(value: self)) {
            return formattedNumber
        } else {
            return String(self)
        }
    }
}
