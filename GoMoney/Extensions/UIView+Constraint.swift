import UIKit

struct AnchoredConstraints {
    public var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}

internal extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil)
    {
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }

        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }

        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }

        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }

        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }

    func centerX(inView view: UIView) {
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingLeft: CGFloat = 0, constant: CGFloat = 0)
    {
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true

        if let left = leftAnchor {
            anchor(left: left, paddingLeft: paddingLeft)
        }
    }

    func setDimensions(height: CGFloat, width: CGFloat) {
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }

    open func centerInSuperview(size: CGSize = .zero) {
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }

        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }

        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }

        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }

    open func centerInSuperview(size: CGSize = .zero, offset: CGPoint = .zero) {
        NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: offset.x).isActive = true

        NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1, constant: offset.y).isActive = true

        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }

        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }

    open func centerXToSuperview() {
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }
    }

    open func centerXToSuperview(offset: CGFloat) {
        let constraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: offset)
        constraint.isActive = true
    }

    open func centerYToSuperview() {
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }
    }

    open func centerYToSuperview(offset: CGFloat) {
        let constraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1, constant: offset)
        constraint.isActive = true
    }

    open func centerYToView(_ toView: UIView) {
        centerYAnchor.constraint(equalTo: toView.centerYAnchor).isActive = true
    }

    open func centerXToView(_ toView: UIView) {
        centerXAnchor.constraint(equalTo: toView.centerXAnchor).isActive = true
    }

    open func fillSuperview(paddingTop: CGFloat = 0,
                            paddingLeft: CGFloat = 0,
                            paddingBottom: CGFloat = 0,
                            paddingRight: CGFloat = 0)
    {
        anchor(top: superview?.safeAreaLayoutGuide.topAnchor,
               left: superview?.leftAnchor,
               bottom: superview?.safeAreaLayoutGuide.bottomAnchor,
               right: superview?.rightAnchor,
               paddingTop: paddingTop,
               paddingLeft: paddingLeft,
               paddingBottom: paddingBottom,
               paddingRight: paddingRight)
    }

    open func setupShadow(opacity: Float = 0, radius: CGFloat = 0, offset: CGSize = .zero, color: UIColor = .black) {
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
    }

    public convenience init(backgroundColor: UIColor? = .clear) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

    func clearConstraints() {
        for subview in subviews {
            subview.clearConstraints()
        }
        removeConstraints(constraints)
    }
}

// MARK: - get index of Enum

internal extension CaseIterable where Self: Equatable {
    var index: Self.AllCases.Index? {
        return Self.allCases.firstIndex { self == $0 }
    }
}

// Screen width.
var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}

// Screen height.
var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

var windowSafeAreaInsets: UIEdgeInsets? {
    return UIApplication.shared.windows.first?.safeAreaInsets
}
