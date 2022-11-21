import UIKit

class AddExpenseForm: UIView {
    private(set) var curDate = Date()
    private(set) var curTag: TransactionTag? {
        didSet {
            fillTag()
        }
    }

    lazy var dateField = {
        let field = AddExpenseField(
            name: "Date",
            defaultValue: DateFormatter.today
        ) { [weak self] textField in
            textField.inputView =
                DatePickerInputView(mode: .date) { [weak textField] date in
                    textField?.text = DateFormatter.dmy().string(from: date)
                    self?.curDate = date
                }

            textField.inputAccessoryView =
                AccessoryView("Select Date", doneTapped: { [weak textField] in
                    textField?.resignFirstResponder()
                })
        }
        return field
    }()

    lazy var categoryField = AddExpenseField(name: "Category", placeHolder: "Enter Category")

    private func setAmountField() {
        let field = amountField.inputField

        guard let currency = SettingsManager.shared.getValue(for: .currencyUnit) as? String else {
            return
        }

        let label = GMLabel(text: currency, style: .regularBold, isCenter: true)

        label.anchor(width: 42, height: 42)
        field.rightView = label
        field.rightViewMode = .always

        let selector = #selector(didChangeAmount)
        field.addTarget(self, action: selector, for: .editingChanged)
    }

    private func setCategoryField() {
        let field = categoryField.inputField

        field.inputView = CategoryPickerInputView(
            type: transType,
            didSelect: { [weak field, weak self] tag in
                self?.curTag = tag
                field?.resignFirstResponder()
            }
        )

        field.inputAccessoryView = AccessoryView(
            "Select Category",
            doneTapped: { [weak field] in
                field?.resignFirstResponder()
            },
            addTapped: { [weak field, weak self] in
                field?.resignFirstResponder()
                self?.createNewTag { tag in
                    if let inputView = field?.inputView as? CategoryPickerInputView {
                        // change category type if user create different icon type.
                        if tag.type != self?.transType.rawValue {
                            self?.controller?.title = "Add \(tag.type.capitalized)"
                            if let changedType = ExpenseType(rawValue: tag.type) {
                                self?.transType = changedType
                                inputView.type = changedType
                            }
                        }
                        inputView.reloadData()
                    }

                    self?.curTag = tag
                    field?.text = tag.name
                }
            },
            shouldShowAdd: true
        )
    }

    lazy var amountField = {
        let field = AddExpenseField(name: "Amount", placeHolder: "Enter Amount") { textField in
            // TODO: Custom Keyboard InputView, use default keyboard temporarily.
            textField.keyboardType = .numberPad
            textField.inputAccessoryView = AccessoryView("Select Amount", doneTapped: { [weak textField] in
                textField?.resignFirstResponder()
            })
        }
        return field
    }()

    lazy var noteField = {
        let field = AddExpenseField(name: "Note", placeHolder: "Enter Note") { textField in
            textField.inputAccessoryView = AccessoryView("Note", doneTapped: { [weak textField] in
                textField?.resignFirstResponder()
            })
        }
        return field
    }()

    weak var delegate: UITextFieldDelegate?
    var transType: ExpenseType = .expense
    var textFieldOnChange: (() -> Void)?
    weak var controller: UIViewController?

    private lazy var stackView: UIStackView = .build { [self] stackView in
        stackView.axis = .vertical
        stackView.spacing = 24

        [dateField, categoryField, amountField, noteField].forEach { field in
            field.inputField.delegate = self.delegate
            stackView.addArrangedSubview(field)
        }
    }

    init(controller: UIViewController, delegate: UITextFieldDelegate? = nil, transType: ExpenseType = .expense, textFieldOnChange: (() -> Void)? = nil) {
        super.init(frame: .zero)

        self.controller = controller
        self.delegate = delegate
        self.transType = transType
        self.textFieldOnChange = textFieldOnChange

        setupView()
        setCategoryField()
        setAmountField()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
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
        return amountField.inputField.text?.replacingOccurrences(of: ",", with: "") ?? ""
    }

    func getNote() -> String {
        return noteField.inputField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }

    @objc
    private func textFieldDidChange() {
        textFieldOnChange?()
    }

    func getExpense() -> Expense? {
        guard let curTag = curTag else {
            return nil
        }
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
        curDate = transaction.occuredOn
        curTag = transaction.tag

        dateField.text = DateFormatter.dmy().string(from: transaction.occuredOn)
        categoryField.text = transaction.tag?.name

        let amountString = String(Int(transaction.amount))
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: ".", with: "")
        let formated = amountString.splitFromEnd(by: 3).joined(separator: ",")
        amountField.text = formated

        noteField.text = transaction.note
    }

    func validateFields(completion: (String?) -> Void) {
        if getAmount().isEmpty {
            return completion(Content.fieldEmpty)
        }

        // TODO: validate amount field

        completion(nil)
    }

    private func createNewTag(completion: @escaping ((TransactionTag) -> Void)) {
        let newTagVC = NewTagViewController()
        newTagVC.onSaveTag = { tag in
            completion(tag)
        }
        controller?.present(newTagVC, animated: true)
    }

    private func fillTag() {
        if let tag = curTag {
            let field = categoryField.inputField
            field.text = tag.name
            let img = GMExpenseIcon()
            img.loadIcon(src: tag.icon)
            img.backgroundColor = K.Color.background
            img.anchor(width: 42, height: 42)
            field.rightView = img
            field.rightViewMode = .always
        }
    }

    private let maxAmount: Double = 1_000_000_000

    @objc
    private func didChangeAmount(sender: UITextField) {
        let text = sender.text ?? ""
        let amountString = text.replacingOccurrences(of: ",", with: "")
        let formated = amountString.splitFromEnd(by: 3).joined(separator: ",")
        sender.text = formated
    }
}

extension AddExpenseForm {
    enum Content {
        static let amountInvalid = "Amount is invalid"
        static let fieldEmpty = "Make sure you fill in all fields"
    }
}
