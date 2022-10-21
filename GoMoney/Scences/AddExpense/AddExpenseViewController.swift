import UIKit

class AddExpenseViewController: GMMainViewController {
    // MARK: - Public properties

    lazy var addExpenseForm = AddExpenseForm(delegate: self)

    // MARK: - Setup Layout

    override func setupLayout() {
        title = "Add Expenses"

        view.addSubviews(addExpenseForm)

        addExpenseForm.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 8,
            paddingLeft: Constant.padding,
            paddingRight: Constant.padding)
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
