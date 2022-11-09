import Foundation

enum Setting: String, Equatable {
    case enablePassword = "Enable password"
    case syncOnWifi = "Auto sync over Wi-fi only"
    case showOnStatusBar = "Show wallet on status bar"
    case currencyUnit = "Currency Unit"
    case dateFormat = "Date Format"
    case intervalSync = "Set interval sync time"

    func getSettingId() -> String {
        let base = "com.ln.gomoney"
        switch self {
        case .enablePassword: return "\(base).enablePassword"
        case .syncOnWifi: return "\(base).syncOnWifi"
        case .showOnStatusBar: return "\(base).showOnStatusBar"
        case .currencyUnit: return "\(base).currencyUnit"
        case .dateFormat: return "\(base).dateFormat"
        case .intervalSync: return "\(base).intervalSync"
        }
    }

    func defaultValue() -> Any {
        switch self {
        case .enablePassword: return false
        case .syncOnWifi: return false
        case .showOnStatusBar: return false

        case .currencyUnit: return CurrencyUnit.dollar.rawValue
        case .dateFormat: return DateFormat.dmy.rawValue
        case .intervalSync: return 60
        }
    }
}

class SettingsManager {
    static let shared = SettingsManager()
    private init() {}

    private let prefs = UserDefaults(suiteName: "com.ln.gomoney.settings")!

    func getValue(for key: Setting) -> Any {
        return prefs.object(forKey: key.getSettingId()) ?? key.defaultValue()
    }

    func setValue(_ value: Any, for key: Setting) {
        prefs.set(value, forKey: key.getSettingId())
    }
}
