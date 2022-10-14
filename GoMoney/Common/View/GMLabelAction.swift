import UIKit

class GMLabelAction: UIView {
    private enum Constant {
        static let height: CGFloat = 40
        static let padding: CGFloat = 2
        static let iconLeftSize: CGFloat = 20
        static let iconRightSize: CGFloat = 12
    }

    lazy var actionLeft: UIImageView = .build {
        $0.contentMode = .scaleAspectFill
    }

    lazy var actionRight: UIImageView = .build {
        $0.contentMode = .scaleAspectFill
    }

    private lazy var actionText: GMLabel = .init()

    init(
        text: String,
        icLeft: String,
        icRight: String = "chevron.right",
        background: UIColor = .gray,
        textColor: UIColor = K.Color.boxLabel,
        builder: ((GMLabelAction) -> Void)? = nil
    ) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        anchor(height: Constant.height)
        addSubviews(actionLeft, actionText, actionRight)

        backgroundColor = K.Color.contentBackground
        layer.cornerRadius = 8

        actionText.text = text
        actionText.textColor = textColor

        actionLeft.image = UIImage(systemName: icLeft)?.withTintColor(
            K.Color.primaryColor,
            renderingMode: .alwaysOriginal
        )

        actionRight.image = UIImage(systemName: icRight)?.withTintColor(
            K.Color.borderOnContentBg,
            renderingMode: .alwaysOriginal
        )

        actionLeft.centerY(inView: self)
        actionText.centerY(inView: self)
        actionRight.centerY(inView: self)

        actionLeft.anchor(
            left: leftAnchor,
            paddingLeft: 8,
            width: Constant.iconLeftSize,
            height: Constant.iconLeftSize
        )

        actionText.anchor(left: actionLeft.rightAnchor, paddingLeft: 8)

        actionRight.anchor(
            right: rightAnchor,
            paddingRight: 8,
            width: Constant.iconRightSize,
            height: Constant.iconRightSize
        )

        builder?(self)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
