import UIKit

class GMFloatingButton: UIControl {
    private(set) var onTap: (() -> Void)?
    private let height: CGFloat = 54
    
    lazy var imageView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    lazy var label = GMLabel(style: .regular, isCenter: true) {
        $0.textColor = .white
    }
    
    lazy var stackView: UIStackView = .build { stackView in
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.addArrangedSubviews(self.imageView, self.label)
    }
    
    init(image: UIImage? = K.Image.edit, text: String = "Edit", textColor: UIColor? = .white, background: UIColor? = K.Color.actionBackground, onTap: (() -> Void)? = nil) {
        super.init(frame: CGRect(x: 0, y: 0, width: 120, height: 64))
        
        backgroundColor = background
        imageView.image = image
        label.text = text
        
        self.onTap = onTap
        addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        setView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        translatesAutoresizingMaskIntoConstraints = false
        anchor(width: 120, height: height)
        
        addSubviews(imageView, label)

        let padding = height / 2 - 10
        imageView.anchor(left: leftAnchor, paddingLeft: padding, width: 24, height: 30)
        imageView.centerYToView(self)
        
        label.anchor(
            top: topAnchor,
            left: imageView.rightAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            paddingLeft: 12,
            paddingRight: padding)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.height / 2
        setupShadow()
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
        if pressed {
            sendActions(for: .touchUpInside)
        }
        pressed = false
    }
    
    func updateTouchAlpha() {
        if alpha != touchAlpha.rawValue {
            UIView.animate(withDuration: 0.3) {
                self.alpha = self.touchAlpha.rawValue
            }
        }
    }
    
    // Action
    @objc
    private func didTapButton() {
        onTap?()
    }
}

extension GMFloatingButton {
    enum TouchAlphaValues: CGFloat {
        case touched = 0.7
        case untouched = 1.0
    }
}
