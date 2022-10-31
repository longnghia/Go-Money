import UIKit

class ButtonAuth: UIButton {
    enum Constants {
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
        stackView.addArrangedSubview(self.btnImg)
        stackView.addArrangedSubview(self.btnText)
    }
    
    init(icon: String, text: String, background: UIColor, textColor: UIColor = .white, builder: ((ButtonAuth) -> Void)? = nil) {
        super.init(frame: .zero)
        setup()
        
        if background == .white {
            layer.borderColor = K.Color.actionBackground.cgColor
        }
        
        backgroundColor = background
        
        addSubviews(stackView)
        
        stackView.centerXToSuperview()
        
        btnImg.image = UIImage(named: icon)
        btnImg.anchor(width: Constants.buttonAuthSize, height: Constants.buttonAuthSize)
        
        btnText.text = text
        btnText.textColor = textColor
        
        builder?(self)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        layer.cornerRadius = Constants.cornerRadius
        layer.borderWidth = Constants.borderWidth
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
    }
}
