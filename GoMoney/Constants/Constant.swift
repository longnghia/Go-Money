import UIKit

struct K {
    enum Color {
        static let primaryColor = UIColor(red: 0.98, green: 0.08, blue: 0.17, alpha: 1.0)
        static let primaryLightColor = UIColor(red: 1.00, green: 0.30, blue: 0.37, alpha: 1.00)
        static let primaryDarkColor = UIColor(red: 0.74, green: 0.00, blue: 0.01, alpha: 1.0)

        static let actionBackground = UIColor(red: 0.05, green: 0.16, blue: 0.28, alpha: 1.00)
        static let contentBackground = UIColor(red: 0.94, green: 0.95, blue: 0.96, alpha: 1.00)

        static let background = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)
        static let white = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)
        static let borderOnBg = UIColor(red: 1, green: 0.99, blue: 0.99, alpha: 1.00)
        static let borderOnContentBg = UIColor(red: 0.55, green: 0.56, blue: 0.56, alpha: 1.00)

        static let boxLabel = UIColor(red: 0.37, green: 0.40, blue: 0.46, alpha: 1.00)
        static let title = UIColor(red: 0.19, green: 0.24, blue: 0.32, alpha: 1.00)
        static let subTitle = UIColor(red: 0.61, green: 0.65, blue: 0.68, alpha: 1.00)

        static let error = UIColor.red

        static let saving = UIColor(red: 0.39, green: 0.73, blue: 0.38, alpha: 1.00)
        static let debt = UIColor.red
    }

    enum Image {
        static let close: UIImage = (.init(named: "ic_back") ?? UIImage()).withRenderingMode(.alwaysOriginal)
        static let user: UIImage = (.init(named: "ic_user") ?? UIImage()).withRenderingMode(.alwaysOriginal)
        static let bell = UIImage(systemName: "bell")
        static let note = UIImage(systemName: "note.text")
        static let power = UIImage(systemName: "power.circle.fill")?.withTintColor(
            .primary, renderingMode: .alwaysOriginal)
        static let edit = UIImage(systemName: "pencil.circle.fill")?.withTintColor(
            UIColor(red: 0.21, green: 0.71, blue: 0.33, alpha: 1.00),
            renderingMode: .alwaysOriginal)
        static let statistic: UIImage = .init(named: "ic_statistic") ?? UIImage()
        static let profile: UIImage = .init(named: "ic_profile") ?? UIImage()
        static let dashboard: UIImage = .init(named: "ic_home") ?? UIImage()
    }

    enum Font {
        static let nova = "ProximaNova-Regular"
        static let novaBold = "ProximaNova-Bold"
    }

    enum Theme {
        static let titleFont: UIFont = .init(name: Font.novaBold, size: 16) ?? UIFont.systemFont(ofSize: 16)
        static let locale: Locale = .init(identifier: "en_US")
    }

    enum Animation {
        static let calculator = "calculator"
    }

    enum URL {
        static let github = "https://github.com/paul-nguyen-goldenowl/Go-Money"
        static let testFlight = "https://testflight.apple.com/join/FQgdoKR0"
    }
}
