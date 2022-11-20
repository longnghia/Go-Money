import DropDown
import UIKit

class DetailViewController: GMMainViewController {
    // MARK: - Properties

    let viewModel = DetailViewModel()

    lazy var detailView = DetailView(transaction: transaction)

    lazy var editButton = GMFloatingButton(
        image: UIImage(systemName: "pencil")?.color(.white),
        text: "Edit"
    ) { [weak self] in
        self?.editTransaction()
    }

    private lazy var dropDown: DropDown = .build { [weak self] dropDown in
        dropDown.dataSource = ["Share as Text", "Share as Image"]
        dropDown.anchorView = self?.navigationItem.rightBarButtonItems![0]

        dropDown.selectionAction = { (index: Int, _: String) in
            if index == 0 {
                self?.shareAsText()
            } else if index == 1 {
                self?.shareAsImage()
            }
        }
    }

    var transaction: Expense? {
        didSet {
            guard let transaction = transaction else {
                return
            }
            viewModel.transaction = transaction
            detailView.transaction = transaction
        }
    }

    private var newTransaction: Expense?

    // MARK: - LifeCircle

    override func configureBackButton() {
        super.configureBackButton()

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "personalhotspot")?.color(.white),
                            style: .done,
                            target: self,
                            action: #selector(dropDownMenu)),

            UIBarButtonItem(image: UIImage(systemName: "trash")?.color(.white),
                            style: .done,
                            target: self,
                            action: #selector(deleteTransaction)),
        ]
    }

    override func setupLayout() {
        title = "Detail"
        super.setupLayout()

        view.addSubviews(detailView, editButton)

        detailView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.rightAnchor,
            paddingTop: 32,
            paddingLeft: 16,
            paddingRight: 16
        )

        editButton.anchor(
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.rightAnchor,
            paddingRight: 16
        )
    }

    // MARK: Functions

    private func editTransaction() {
        guard transaction != nil else {
            alert(
                title: "Error",
                message: "Can't edit transaction",
                actionTitle: "Cancel"
            )
            return
        }

        let vc = EditViewController()
        vc.transaction = transaction
        vc.onApply = { newTrans in
            self.newTransaction = newTrans
            self.applyNewTransaction(newTrans)
        }

        present(vc, animated: true)
    }

    private func applyNewTransaction(_ newTrans: Expense) {
        detailView.transaction = newTrans
        viewModel.applyTransaction(newTrans: newTrans) { [weak self] err in
            DispatchQueue.main.async {
                if let err = err {
                    self?.alert(
                        title: "Error",
                        message: err.localizedDescription,
                        actionTitle: "Cancel"
                    )
                } else {
                    self?.notifyDataDidChange()
                    self?.snackBar(
                        message: "Transaction updated successfully!",
                        actionText: "OK"
                    )
                }
            }
        }
    }

    @objc func deleteTransaction() {
        guard let transaction = transaction else {
            alert(title: "Error", message: DataError.noTransactions.localizedDescription)
            return
        }
        viewModel.deleteTransaction(transaction) { [weak self] err in
            DispatchQueue.main.async {
                if let err = err {
                    self?.alert(title: "Error", message: err.localizedDescription)
                } else {
                    self?.notifyDataDidChange()
                    self?.snackBar(message: "Remove Transaction Sucessfully!")
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    private func shareAsText(completion _: ((Error?) -> Void)? = nil) {
        let transaction = newTransaction ?? transaction
        guard let transaction = transaction else {
            return
        }

        let shareText = transaction.createShareText()

        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        present(activityVC, animated: true)
    }

    private func shareAsImage() {
        let image = detailView.asImage()

        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityVC, animated: true)
    }

    @objc
    private func dropDownMenu() {
        dropDown.show()
    }
}
