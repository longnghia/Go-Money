import UIKit

class GMLabelAction: UIView {
    private enum Constant {
        static let height: CGFloat = 40
        static let padding: CGFloat = 2
        static let iconSize = height - 2 * padding
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
        builder: ((GMLabelAction) -> Void)? = nil
    ) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: Constant.height))
        translatesAutoresizingMaskIntoConstraints = false

        addSubviews(actionLeft, actionText, actionRight)
        backgroundColor = background

        layer.cornerRadius = 8

        actionText.text = text

        actionLeft.image = UIImage(systemName: icLeft)?.withTintColor(
            K.Color.primaryColor,
            renderingMode: .alwaysOriginal
        )

        actionRight.image = UIImage(systemName: icRight)?.withTintColor(
            K.Color.contentBackground,
            renderingMode: .alwaysOriginal
        )

        actionLeft.centerY(inView: self)
        actionText.centerY(inView: self)
        actionRight.centerY(inView: self)

        actionLeft.anchor(
            left: leftAnchor,
            paddingLeft: 8,
            width: Constant.iconSize,
            height: Constant.iconSize
        )

        actionText.anchor(left: actionLeft.rightAnchor, paddingLeft: 8)

        actionRight.anchor(
            right: rightAnchor,
            paddingRight: 8,
            width: Constant.iconSize,
            height: Constant.iconSize
        )

        builder?(self)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
