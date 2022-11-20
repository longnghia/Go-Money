import UIKit

extension UIBarButtonItem {
    func setTextAttributes(font: UIFont? = K.Theme.titleFont, color: UIColor = .black, state: UIControl.State = .normal) {
        setTitleTextAttributes([
            NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: color,
        ],
        for: state)
    }
}
