import UIKit

class AddExpenseViewController: GMMainViewController {
    // MARK: - Public properties

    var type: ExpenseType = .expense

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

    // MARK: - ViewModel

    private let viewModel = AddExpenseViewModel()

    // MARK: - Setup Layout

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

        view.addSubviews(addExpenseForm, errorLabel)

        addExpenseForm.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 8,
            paddingLeft: Constant.padding,
            paddingRight: Constant.padding)

        errorLabel.anchor(
            top: addExpenseForm.bottomAnchor,
            left: addExpenseForm.leftAnchor,
            right: addExpenseForm.rightAnchor,
            paddingTop: 24)
    }

    @objc
    private func saveExpense() {
        view.endEditing(true)

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

                        let alert = UIAlertController(
                            title: "Success!",
                            message: "Continue adding transactions?",
                            preferredStyle: .alert)
                        alert.addAction(UIAlertAction(
                            title: "Cancel",
                            style: .default,
                            handler: { _ in
                                self?.didTapBack()
                            }))
                        alert.addAction(UIAlertAction(
                            title: "OK",
                            style: .default,
                            handler: { _ in
                                self?.addExpenseForm.clearFields()
                            }))
                        self?.present(alert, animated: true, completion: nil)
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
