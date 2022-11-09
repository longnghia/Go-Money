import UIKit

extension DateFormatter {
    static let dmy = {
        let dateFormater = DateFormatter()
        let format = SettingsManager.shared.getValue(for: .dateFormat) as? String
        dateFormater.dateFormat = format ?? DateFormat.dmy.rawValue
        dateFormater.locale = K.Theme.locale
        return dateFormater
    }

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

    static let today = dmy().string(from: Date())
}
