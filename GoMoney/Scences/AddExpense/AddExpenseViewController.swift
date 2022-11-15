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
        delegate: self,
        transType: type,
        textFieldOnChange: { [weak self] in
            self?.errorLabel.text = nil
        })

    lazy var errorLabel: GMLabel = .init(style: .smallBold, isCenter: true) {
        $0.textColor = K.Color.error
        $0.numberOfLines = 0
    }

    lazy var saveButton = GMFloatingButton(
        image: UIImage(systemName: "plus.circle")?.color(.white),
        text: "Save")
    { [weak self] in
        self?.saveExpense()
    }

    var saveButtonAnchor: NSLayoutConstraint?
    var bottomInset: CGFloat = 100

    // MARK: - ViewModel

    private let viewModel = AddExpenseViewModel()

    // MARK: - Setup Layout

    override func viewDidLoad() {
        super.viewDidLoad()
        setKeyboardNotification()
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
            saveButton)

        addExpenseForm.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 32,
            paddingLeft: Constant.padding,
            paddingRight: Constant.padding)

        errorLabel.anchor(
            top: addExpenseForm.bottomAnchor,
            left: addExpenseForm.leftAnchor,
            right: addExpenseForm.rightAnchor,
            paddingTop: 24)

        saveButton.anchor(
            right: view.rightAnchor,
            paddingRight: 16)

        saveButtonAnchor = saveButton.bottomAnchor.constraint(
            equalTo: view.bottomAnchor,
            constant: -bottomInset)

        saveButtonAnchor?.isActive = true
    }

    // MARK: - Keyboard

    private func setKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)

        hideKeyboardOnTap()
    }

    @objc func handleKeyboardWillShow(notification: NSNotification) {
        let kFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let kDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        guard let height = kFrame?.height, let duration = kDuration else { return }

        UIView.animate(withDuration: duration) { [self] in
            saveButtonAnchor?.constant = -(height + 16)
            saveButton.layoutIfNeeded()
        }
    }

    @objc func handleKeyboardWillHide(notification: NSNotification) {
        let kFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let kDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        guard let _ = kFrame?.height, let duration = kDuration else { return }

        UIView.animate(withDuration: duration) { [self] in
            saveButtonAnchor?.constant = -bottomInset
            saveButton.layoutIfNeeded()
        }
    }

    func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
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

                        let doneAction = UIAlertAction(
                            title: "Done",
                            style: .cancel,
                            handler: { _ in
                                self?.didTapBack()
                            })

                        let continueAction = UIAlertAction(
                            title: "Add more",
                            style: .default,
                            handler: { _ in
                                self?.addExpenseForm.clearFields()
                            })

                        self?.alert(
                            type: .actionSheet,
                            with: "Success!",
                            message: nil,
                            actions: [continueAction, doneAction],
                            showCancel: false)
                    }
                }
            }
        } else {
            alert(title: "Can't add transaction!", actionTitle: "Error")
        }
    }
}

extension AddExpenseViewController {
    private enum Constant {
        static let padding: CGFloat = 16
    }
}

extension AddExpenseViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // TODO: Editting animation
    }
}
