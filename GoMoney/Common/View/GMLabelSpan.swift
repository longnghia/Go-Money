import UIKit

/// Create a UILabel text with a clickable-link inside
/// Usage:
/// ```
/// let signUpText: GMLabelSpan = .init(
///     text: "Don't have an account? Signup",
///     span: "Signup",
/// )
/// ```
class GMLabelSpan: UILabel {
    init(
        text: String,
        span: String,
        style: GMLabelStyle,
        underline: Bool = false,
        builder: ((GMLabelSpan) -> Void)? = nil
    ) {
        super.init(frame: .zero)

        let link = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: span)
        if underline {
            link.addAttribute(
                NSAttributedString.Key.underlineStyle,
                value: NSUnderlineStyle.single.rawValue,
                range: range
            )
        }
        link.addAttribute(NSAttributedString.Key.font, value: UIFont(
            name: style.getFont(),
            size: style.getSize()
        ) ?? .nova(),
        range: NSRangeFromString(text))
        link.addAttribute(NSAttributedString.Key.foregroundColor, value: K.Color.primaryColor, range: range)
        attributedText = link

        isUserInteractionEnabled = true
        translatesAutoresizingMaskIntoConstraints = false

        builder?(self)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
