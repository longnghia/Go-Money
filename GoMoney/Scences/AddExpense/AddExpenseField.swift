import UIKit

class AddExpenseField: UIView {
    var placeHolder: String? {
        didSet {
            inputField.placeholder = placeHolder
        }
    }

    var text: String? {
        didSet {
            inputField.text = text
        }
    }

    lazy var label = GMLabel {
        $0.textColor = .darkGray
        $0.font = .nova(20)
    }

    lazy var inputField: ExpenseTextField = .build {
        $0.tintColor = .clear
        $0.font = .nova(20)

        let attributes = [
            NSAttributedString.Key.font: UIFont.nova(16),
        ]

        $0.attributedPlaceholder = NSAttributedString(string: self.placeHolder ?? "", attributes: attributes)
    }

    private(set) var name: String = ""
    private(set) var defaultValue: String = ""

    init(name: String, defaultValue: String = "", placeHolder: String = "", makeInputView: ((ExpenseTextField) -> Void)? = nil) {
        super.init(frame: .zero)

        self.name = name
        self.placeHolder = placeHolder
        self.defaultValue = defaultValue
        setView()
        makeInputView?(inputField)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setView() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubviews(label, inputField)
        label.text = name
        inputField.text = defaultValue

        heightAnchor.constraint(equalToConstant: 56).isActive = true

        label.anchor(
            top: topAnchor,
            left: leftAnchor
        )
        label.centerYToView(self)
        label.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3).isActive = true

        inputField.anchor(
            top: label.topAnchor,
            left: label.rightAnchor,
            right: rightAnchor,
            paddingLeft: 8
        )
        inputField.centerYToView(self)
    }
}
