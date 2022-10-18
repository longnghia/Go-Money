//
//  UIView+Extension.swift
//  GoMoney
//
//  Created by Golden Owl on 12/10/2022.
//

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
            blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor)
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
        shadowRadius: CGFloat = 3)
    {
        layer.masksToBounds = false
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
}
