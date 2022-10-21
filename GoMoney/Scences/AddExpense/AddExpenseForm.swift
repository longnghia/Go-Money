import UIKit

class AddExpenseForm: UIView {
    lazy var dateField = {
        let field = AddExpenseField(name: "Date", defaultValue: DateFormatter.today) { textField in
            textField.inputView = DatePickerInputView(mode: .dateAndTime) { date in
                textField.text = DateFormatter.date.string(from: date)
            }
            textField.inputAccessoryView = AccessoryView("Select Date", doneTapped: {
                textField.resignFirstResponder()
            })
        }
        return field
    }()

    lazy var categoryField = {
        let field = AddExpenseField(name: "Category") { textField in
            textField.inputView = CategoryPickerInputView(type: .expense) { tag in
                textField.text = tag.name
                textField.resignFirstResponder()
            }
            textField.inputAccessoryView = AccessoryView("Select Category", doneTapped: {
                textField.resignFirstResponder()
            })
        }
        return field
    }()

    lazy var amountField = {
        let field = AddExpenseField(name: "Amount") { textField in
            // TODO: Custom Keyboard InputView, use default keyboard temporarily.
            textField.keyboardType = .numberPad
            textField.inputAccessoryView = AccessoryView("Select Amount", doneTapped: {
                textField.resignFirstResponder()
            })
        }
        return field
    }()

    lazy var noteField = {
        let field = AddExpenseField(name: "Note") { textField in
            textField.inputAccessoryView = AccessoryView("Note", doneTapped: {
                textField.resignFirstResponder()
            })
        }
        return field
    }()

    var delegate: UITextFieldDelegate?

    private lazy var stackView: UIStackView = .build { [self] stackView in
        stackView.axis = .vertical
        stackView.spacing = 24

        [dateField, categoryField, amountField, noteField].forEach { field in
            field.inputField.delegate = self.delegate
            stackView.addArrangedSubview(field)
        }
    }

    init(delegate: UITextFieldDelegate) {
        super.init(frame: .zero)

        self.delegate = delegate
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(stackView)

        stackView.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
    }
}
