import UIKit

class GMLabelActionView: UIControl {
    private enum Constant {
        static let height: CGFloat = 40
        static let padding: CGFloat = 2
        static let iconLeftSize: CGFloat = 20
        static let iconRightSize: CGFloat = 12
    }

    lazy var actionLeft: UIImageView = .build {
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = false
    }

    lazy var actionRight: UIImageView = .build {
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = false
    }

    private(set) var action: (() -> Void)?

    private lazy var actionText = GMLabel {
        $0.isUserInteractionEnabled = false
    }

    init(
        text: String,
        icLeft: UIImage?,
        icRight: UIImage? = UIImage(systemName: "chevron.right"),
        background _: UIColor = .gray,
        textColor: UIColor = K.Color.boxLabel,
        action: (() -> Void)? = nil
    ) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        self.action = action
        addTarget(self, action: #selector(onTap), for: .touchUpInside)

        anchor(height: Constant.height)
        addSubviews(actionLeft, actionText, actionRight)

        backgroundColor = K.Color.contentBackground
        layer.cornerRadius = 8

        actionText.text = text
        actionText.textColor = textColor

        actionLeft.image = icLeft?.withTintColor(
            K.Color.primaryColor,
            renderingMode: .alwaysOriginal
        )

        if let icRight = icRight {
            actionRight.image = icRight.withTintColor(
                K.Color.borderOnContentBg,
                renderingMode: .alwaysOriginal
            )
        } else {
            actionRight.isHidden = true
        }

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
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @objc
    private func onTap() {
        action?()
    }

    // MARK: - Touches

    var touchAlpha: TouchAlphaValues = .untouched {
        didSet {
            updateTouchAlpha()
        }
    }

    var pressed: Bool = false {
        didSet {
            touchAlpha = pressed ? .touched : .untouched
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        pressed = true
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        pressed = false
    }

    func updateTouchAlpha() {
        if alpha != touchAlpha.rawValue {
            UIView.animate(withDuration: 0.3) {
                self.alpha = self.touchAlpha.rawValue
            }
        }
    }
}

extension GMLabelActionView {
    enum TouchAlphaValues: CGFloat {
        case touched = 0.7
        case untouched = 1.0
    }
}
