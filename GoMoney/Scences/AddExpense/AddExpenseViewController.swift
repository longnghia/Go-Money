import SCLAlertView
import UIKit

class AddExpenseViewController: GMMainViewController {
    // MARK: - Public properties

    var type: ExpenseType = .expense
    var transaction: Expense? {
        didSet {
            if let transaction = transaction {
                addExpenseForm.fillTransaction(transaction)
            }
        }
    }

    lazy var addExpenseForm = AddExpenseForm(
        controller: self,
        delegate: self,
        transType: type,
        textFieldOnChange: { [weak self] in
            self?.errorLabel.text = nil
        }
    )

    lazy var errorLabel: GMLabel = .init(style: .smallBold, isCenter: true) {
        $0.textColor = K.Color.error
        $0.numberOfLines = 0
    }

    lazy var saveButton = GMFloatingButton(
        image: UIImage(systemName: "plus.circle")?.color(.white),
        text: "Save"
    ) { [weak self] in
        self?.saveExpense()
    }

    var saveButtonAnchor: NSLayoutConstraint?
    var bottomInset: CGFloat = 100

    // MARK: - ViewModel

    private let viewModel = AddExpenseViewModel()

    // MARK: - Setup Layout

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
    }

    private func setupKeyboard() {
        setupKeyboard(onKeyboardWillShow: { height, duration in
            UIView.animate(withDuration: duration) { [self] in
                saveButtonAnchor?.constant = -(height + 16)
                saveButton.layoutIfNeeded()
            }
        }, onKeyboardWillHide: { _, duration in
            UIView.animate(withDuration: duration) { [self] in
                saveButtonAnchor?.constant = -bottomInset
                saveButton.layoutIfNeeded()
            }
        })
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func configureBackButton() {
        super.configureBackButton()

        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image: UIImage(systemName: "checkmark.circle")?.color(.white),
                            style: .done,
                            target: self,
                            action: #selector(saveExpense))
    }

    override func setupLayout() {
        title = type == .expense ? "Add Expense" : "Add Income"

        view.addSubviews(
            addExpenseForm,
            errorLabel,
            saveButton
        )

        addExpenseForm.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 32,
            paddingLeft: Constant.padding,
            paddingRight: Constant.padding
        )

        errorLabel.anchor(
            top: addExpenseForm.bottomAnchor,
            left: addExpenseForm.leftAnchor,
            right: addExpenseForm.rightAnchor,
            paddingTop: 32
        )

        saveButton.anchor(
            right: view.rightAnchor,
            paddingRight: 16
        )

        saveButtonAnchor = saveButton.bottomAnchor.constraint(
            equalTo: view.bottomAnchor,
            constant: -bottomInset
        )

        saveButtonAnchor?.isActive = true
    }

    @objc
    private func saveExpense() {
        hideKeyboard()

        addExpenseForm.validateFields { err in
            if let err = err {
                errorLabel.text = err
            } else {
                errorLabel.text = ""
                addExpense()
            }
        }
    }

    private func addExpense() {
        if let expense = addExpenseForm.getExpense() {
            viewModel.addExpense(expense: expense) { [weak self] err in
                DispatchQueue.main.async {
                    if let err = err {
                        self?.alert(title: "Error", message: err.localizedDescription, actionTitle: "Cancel")
                    } else {
                        self?.notifyDataDidChange()
                        self?.showSuccessAlert()
                    }
                }
            }
        } else {
            alert(title: "Can't add transaction!", actionTitle: "Error")
        }
    }

    private func showSuccessAlert() {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: .nova(20),
            kTextFont: .nova(14),
            kButtonFont: .novaBold(14),
            showCloseButton: false,
            circleBackgroundColor: .action
        )

        let btnColor = UIColor.action.withAlphaComponent(0.8)

        let alert = SCLAlertView(appearance: appearance)
        alert.iconTintColor = .action

        alert.addButton("Add more", backgroundColor: btnColor) {
            self.addExpenseForm.clearFields()
        }
        let doneBtn = alert.addButton(
            "Done",
            backgroundColor: .white,
            textColor: .action
        ) {
            self.didTapBack()
        }

        doneBtn.layer.borderColor = btnColor.cgColor
        doneBtn.layer.borderWidth = 2.0

        alert.showTitle(
            "Success",
            subTitle: "Transaction saved.",
            style: .success,
            colorStyle: 0xEFF3F6,
            colorTextButton: 0xFFFFFF
        )
    }
}

extension AddExpenseViewController {
    private enum Constant {
        static let padding: CGFloat = 16
    }
}

extension AddExpenseViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_: UITextField) {
        // TODO: Editting animation
    }
}
