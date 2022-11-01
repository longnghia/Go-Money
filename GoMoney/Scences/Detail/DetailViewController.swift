import UIKit

class DetailViewController: GMMainViewController {
    // MARK: - Properties

    let viewModel = DetailViewModel()
    
    lazy var detailView = DetailView(transaction: transaction)
    
    lazy var editButton = GMFloatingButton(
        image: UIImage(systemName: "pencil")?.color(.white),
        text: "Edit")
    { [weak self] in
        self?.editTransaction()
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
    
    // MARK: - LifeCircle
    
    override func configureBackButton() {
        super.configureBackButton()

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "personalhotspot")?.color(.white),
                            style: .done,
                            target: self,
                            action: #selector(shareTransaction)),
            
            UIBarButtonItem(image: UIImage(systemName: "trash")?.color(.white),
                            style: .done,
                            target: self,
                            action: #selector(deleteTransaction))
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
            paddingRight: 16)
        
        editButton.anchor(
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.rightAnchor,
            paddingRight: 16)
    }
    
    // MARK: Functions
    
    private func editTransaction() {
        guard transaction != nil else {
            alert(
                title: "Error",
                message: "Can't edit transaction",
                actionTitle: "Cancel")
            return
        }
        
        let vc = EditViewController()
        vc.transaction = transaction
        vc.onApply = { newTrans in
            self.detailView.transaction = newTrans
            self.viewModel.applyTransaction(newTrans: newTrans) { [weak self] err in
                DispatchQueue.main.async {
                    if let err = err {
                        self?.alert(
                            title: "Error",
                            message: err.localizedDescription,
                            actionTitle: "Cancel")
                    } else {
                        self?.notifyDataDidChange()
                        self?.snackBar(
                            message: "Transaction updated successfully!",
                            actionText: "OK")
                    }
                }
            }
        }
        
        present(vc, animated: true)
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
    
    @objc func shareTransaction() {
        print("share transaction")
    }
}
