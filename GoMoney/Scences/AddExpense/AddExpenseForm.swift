import UIKit

class AddExpenseForm: UIView {
    private(set) var curDate = Date()
    private(set) var curTag: TransactionTag?

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

    lazy var categoryField = AddExpenseField(name: "Category")

    private func setCategoryField() {
        let field = categoryField.inputField

        field.inputView = CategoryPickerInputView(
            type: transType,
            didSelect: { [weak field, weak self] tag in
                self?.curTag = tag
                field?.text = tag.name
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
                            self?.controller?.title = "Add \(tag.type)"
                            if let changedType = ExpenseType(rawValue: tag.type) {
                                print("change type: \(inputView.type)-\(changedType)")
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
        let field = AddExpenseField(name: "Amount") { textField in
            // TODO: Custom Keyboard InputView, use default keyboard temporarily.
            textField.keyboardType = .numberPad
            textField.inputAccessoryView = AccessoryView("Select Amount", doneTapped: { [weak textField] in
                textField?.resignFirstResponder()
            })
        }
        return field
    }()

    lazy var noteField = {
        let field = AddExpenseField(name: "Note") { textField in
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

    private func createNewTag(completion: @escaping ((TransactionTag) -> Void)) {
        let newTagVC = NewTagViewController()
        newTagVC.onSaveTag = { tag in
            completion(tag)
        }
        controller?.present(newTagVC, animated: true)
    }
}

extension AddExpenseForm {
    enum Content {
        static let amountInvalid = "Amount is invalid"
        static let fieldEmpty = "Make sure you fill in all fields"
    }
}
