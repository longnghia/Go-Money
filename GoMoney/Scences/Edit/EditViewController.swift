import UIKit

class EditViewController: GMMainViewController {
    // MARK: - Properties

    var onApply: ((Expense) -> Void)?

    var transaction: Expense? {
        didSet {
            guard let transaction = transaction else {
                return
            }
            setView(transaction)
        }
    }

    var form: AddExpenseForm?

    lazy var errorLabel: GMLabel = .init(style: .smallBold, isCenter: true) {
        $0.textColor = K.Color.error
        $0.numberOfLines = 0
    }

    private lazy var cancelBtn = GMButton(text: "Cancel", color: K.Color.actionBackground, tapAction: { [weak self] in
        self?.dismiss(animated: true)
    })

    private lazy var applyBtn = GMButton(text: "Apply", color: K.Color.primaryColor, tapAction: { [weak self] in
        guard let updated = self?.form?.getExpense() else {
            self?.alert(title: "Error", message: "Transaction nil", actionTitle: "Cancel")
            return
        }
        self?.onApply?(updated)
        self?.dismiss(animated: true)
    })

    override func setupLayout() {
        super.setupLayout()
        guard let form = form else {
            return
        }

        view.addSubviews(form, errorLabel, cancelBtn, applyBtn)

        form.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 8,
            paddingLeft: 16,
            paddingRight: 16)

        errorLabel.anchor(
            top: form.bottomAnchor,
            left: form.leftAnchor,
            right: form.rightAnchor,
            paddingTop: 24)
    }

    private func setView(_ transaction: Expense) {
        let type: ExpenseType = transaction.type == ExpenseType.expense.rawValue ? .expense : .income
        form = AddExpenseForm(transType: type, textFieldOnChange: { [weak self] in
            self?.errorLabel.text = nil
        })
        form?.fillTransaction(transaction)
    }
}
