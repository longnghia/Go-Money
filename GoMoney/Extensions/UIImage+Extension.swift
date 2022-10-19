import UIKit

extension UIImage {
    func color(_ color: UIColor?) -> UIImage {
        if let color = color {
            return withTintColor(color, renderingMode: .alwaysOriginal)
        }
        return self
    }

    func black() -> UIImage {
        return withTintColor(.black, renderingMode: .alwaysOriginal)
    }

    func white() -> UIImage {
        return withTintColor(.white, renderingMode: .alwaysOriginal)
    }

    func primary() -> UIImage {
        return withTintColor(.primary, renderingMode: .alwaysOriginal)
    }
}
