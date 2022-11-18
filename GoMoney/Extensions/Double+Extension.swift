import Foundation

extension Double {
    func formatWithCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        if let formattedNumber = numberFormatter.string(from: NSNumber(value: self)) {
            return formattedNumber
        } else {
            return String(self)
        }
    }
}
