import UIKit

class TextFieldSignUp: UIView {
    private lazy var inputTitle: GMLabel = .init(style: .regular) {
        $0.textColor = K.Color.subTitle
    }

    lazy var inputField: GMTextField = {
        let textField = GMTextField()
        textField.font = .nova(18)
        return textField
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.addArrangedSubviews(inputTitle, inputField)

        inputTitle.anchor(
            left: stackView.leftAnchor,
            right: stackView.rightAnchor
        )
        inputField.anchor(
            left: inputTitle.leftAnchor,
            right: inputTitle.rightAnchor
        )

        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    init(
        title: String = "",
        placeHolder: String = "",
        type: UIKeyboardType = .default,
        secure: Bool = false,
        delegate: UITextFieldDelegate? = nil,
        builder: ((TextFieldSignUp) -> Void)? = nil
    ) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        inputTitle.text = title
        inputField.keyboardType = type
        inputField.placeholder = placeHolder
        inputField.delegate = delegate
        inputField.isSecureTextEntry = secure

        addSubview(stackView)

        stackView.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )

        builder?(self)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
