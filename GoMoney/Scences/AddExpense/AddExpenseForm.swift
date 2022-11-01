import UIKit

class AddExpenseForm: UIView {
    private(set) var curDate = Date()
    private(set) var curTag: TransactionTag = .food

    lazy var dateField = {
        let field = AddExpenseField(name: "Date", defaultValue: DateFormatter.today) { textField in
            textField.inputView = DatePickerInputView(mode: .date) { [weak self] date in
                textField.text = DateFormatter.ddmmyyyy.string(from: date)
                self?.curDate = date
            }
            textField.inputAccessoryView = AccessoryView("Select Date", doneTapped: {
                textField.resignFirstResponder()
            })
        }
        return field
    }()

    lazy var categoryField = {
        let defaultTag: TransactionTag = transType == .expense ? .food : .salary

        let field = AddExpenseField(name: "Category", defaultValue: defaultTag.getName()) { textField in
            textField.inputView = CategoryPickerInputView(type: self.transType) { [weak self] tag in
                self?.curTag = tag
                textField.text = tag.getName()
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
    var transType: ExpenseType = .expense
    var textFieldOnChange: (() -> Void)?

    private lazy var stackView: UIStackView = .build { [self] stackView in
        stackView.axis = .vertical
        stackView.spacing = 24

        [dateField, categoryField, amountField, noteField].forEach { field in
            field.inputField.delegate = self.delegate
            stackView.addArrangedSubview(field)
        }
    }

    init(delegate: UITextFieldDelegate? = nil, transType: ExpenseType = .expense, textFieldOnChange: (() -> Void)? = nil) {
        super.init(frame: .zero)

        self.delegate = delegate
        self.transType = transType
        self.textFieldOnChange = textFieldOnChange

        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(stackView)

        [dateField, categoryField, amountField, noteField].forEach {
            $0.inputField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }

        stackView.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
    }

    // MARK: Actions

    func getAmount() -> String {
        return amountField.inputField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }

    func getNote() -> String {
        return noteField.inputField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }

    @objc
    private func textFieldDidChange() {
        textFieldOnChange?()
    }

    func getExpense() -> Expense? {
        if let amount = Double(getAmount()) {
            return Expense(
                type: transType,
                tag: curTag,
                amount: amount,
                note: getNote(),
                occuredOn: curDate
            )
        } else {
            return nil
        }
    }

    func clearFields() {
        [amountField, noteField].forEach {
            $0.inputField.text = nil
        }
    }

    func fillTransaction(_ transaction: Expense) {
        dateField.text = DateFormatter.ddmmyyyy.string(from: transaction.occuredOn)
        categoryField.text = transaction.tag
        amountField.text = String(transaction.amount)
        noteField.text = transaction.note
    }

    func validateFields(completion: (String?) -> Void) {
        if getAmount().isEmpty {
            return completion(Content.fieldEmpty)
        }

        // TODO: validate amount field

        completion(nil)
    }
}

extension AddExpenseForm {
    enum Content {
        static let amountInvalid = "Amount is invalid"
        static let fieldEmpty = "Make sure you fill in all fields"
    }
}
