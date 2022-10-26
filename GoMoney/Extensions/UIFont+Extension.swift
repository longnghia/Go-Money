import UIKit

extension UIFont {
    static func nova(_ fontSize: CGFloat = 16) -> UIFont {
        return UIFont(name: K.Font.nova, size: fontSize) ?? .systemFont(ofSize: fontSize)
    }

    static func novaBold(_ fontSize: CGFloat = 16) -> UIFont {
        return UIFont(name: K.Font.novaBold, size: fontSize) ?? .systemFont(ofSize: fontSize)
    }
}
