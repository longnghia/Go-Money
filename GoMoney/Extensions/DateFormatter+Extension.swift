import UIKit

extension DateFormatter {
    static let ddmmyyyy = {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd-MM-yyyy"
        return dateFormater
    }()
}
