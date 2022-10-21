import UIKit

extension DateFormatter {
    static let ddmmyyyy = {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd-MM-yyyy"
        return dateFormater
    }()

    static let date = {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd-MMM-yyyy hh:mm a"
        return dateFormater
    }()

    static let today = date.string(from: Date())
}
