import UIKit

class ButtonAuth: UIButton {
    private enum Constants {
        static let buttonAuthSize: CGFloat = 40
        static let cornerRadius: CGFloat = 8
        static let borderWidth: CGFloat = 1
        static let spacing: CGFloat = 16
    }

    private lazy var btnImg: UIImageView = .build { icon in
        icon.contentMode = .scaleAspectFill
    }

    private lazy var btnText: GMLabel = .init(style: .regular, isCenter: true) {
        $0.textColor = .white
    }

    private lazy var stackView: UIStackView = .build { stackView in
        stackView.axis = .horizontal
        stackView.spacing = Constants.spacing
        stackView.addArrangedSubviews(self.btnImg, self.btnText)
        stackView.isUserInteractionEnabled = false
    }

    private var tapAction: (() -> Void)?

    init(icon: String, text: String, background: UIColor, textColor: UIColor = .white, tapAction: @escaping () -> Void, builder: ((ButtonAuth) -> Void)? = nil) {
        super.init(frame: .zero)
        setup()

        if background == .white {
            layer.borderColor = UIColor.action.cgColor
        }

        backgroundColor = background

        addSubviews(stackView)

        stackView.centerXToSuperview()

        btnImg.image = UIImage(named: icon)
        btnImg.anchor(width: Constants.buttonAuthSize, height: Constants.buttonAuthSize)

        btnText.text = text
        btnText.textColor = textColor

        self.tapAction = tapAction
        addTarget(self, action: #selector(didTapButton), for: .touchUpInside)

        builder?(self)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        layer.cornerRadius = Constants.cornerRadius
        layer.borderWidth = Constants.borderWidth
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
    }

    @objc
    private func didTapButton() {
        tapAction?()
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
            UIView.animate(withDuration: 0.2) {
                self.alpha = self.touchAlpha.rawValue
            }
        }
    }
}

extension ButtonAuth {
    enum TouchAlphaValues: CGFloat {
        case touched = 0.7
        case untouched = 1.0
    }
}
