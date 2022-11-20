import UIKit

class SettingsFooterView: UIView {
    lazy var textLabel = GMLabel(style: .small)

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textLabel)

        textLabel.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            paddingTop: 8,
            paddingLeft: 16,
            paddingBottom: 16,
            paddingRight: 16
        )
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
