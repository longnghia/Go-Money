import UIKit

extension DateFormatter {
    static let ddmmyyyy = {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd-MM-yyyy"
        dateFormater.locale = K.Theme.locale
        return dateFormater
    }()

    static let eee = {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "EEE"
        dateFormater.locale = K.Theme.locale
        return dateFormater
    }()

    static let mmm = {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MMM"
        dateFormater.locale = K.Theme.locale
        return dateFormater
    }()

    static let dd = {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd"
        dateFormater.locale = K.Theme.locale
        return dateFormater
    }()

    static let date = {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd-MMM-yyyy hh:mm a"
        dateFormater.locale = K.Theme.locale
        return dateFormater
    }()

    static let today = ddmmyyyy.string(from: Date())
}
