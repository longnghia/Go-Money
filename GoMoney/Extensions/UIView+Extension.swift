import UIKit

extension UIView {
    static func build<T: UIView>(_ builder: ((T) -> Void)? = nil) -> T {
        let view = T()
        view.translatesAutoresizingMaskIntoConstraints = false
        builder?(view)

        return view
    }

    func addSubviews(_ views: UIView...) {
        views.forEach(addSubview)
    }

    func addBlurEffect(using style: UIBlurEffect.Style) {
        guard !UIAccessibility.isReduceTransparencyEnabled else { return }

        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.clipsToBounds = true
        blurEffectView.isUserInteractionEnabled = false
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(blurEffectView, at: 0)

        NSLayoutConstraint.activate([
            blurEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurEffectView.topAnchor.constraint(equalTo: topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    func addRoundedCorners(_ cornersToRound: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: cornersToRound,
                                    cornerRadii: CGSize(width: radius, height: radius))

        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }

    func addDropShadow(
        shadowColor: CGColor = UIColor.darkGray.cgColor,
        shadowOffset: CGSize = CGSize(width: 3, height: 3),
        shadowOpacity: Float = 0.4,
        shadowRadius: CGFloat = 3
    ) {
        layer.masksToBounds = false
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }

    func showTapAnimation(_ completion: (() -> Void)? = nil) {
        isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveLinear,
                       animations: { [weak self] in
                           self?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                       }) { _ in
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveLinear,
                           animations: { [weak self] in
                               self?.transform = CGAffineTransform(scaleX: 1, y: 1)
                           }) { [weak self] _ in
                self?.isUserInteractionEnabled = true
                completion?()
            }
        }
    }

    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
