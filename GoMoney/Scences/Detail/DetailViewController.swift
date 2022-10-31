import UIKit

class DetailViewController: GMMainViewController {
    // MARK: - Properties

    let viewModel = DetailViewModel()
    
    lazy var detailView = DetailView(transaction: transaction)
    
    var transaction: Expense? {
        didSet {
            guard let transaction = transaction else {
                return
            }
            viewModel.transaction = transaction
            setView(transaction: transaction)
        }
    }
    
    // MARK: - LifeCircle
    
    override func configureBackButton() {
        super.configureBackButton()

        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image: UIImage(systemName: "pencil.circle")?.color(.white),
                            style: .done,
                            target: self,
                            action: #selector(editTransaction))
    }
    
    override func setupLayout() {
        title = "Detail"
        super.setupLayout()
        
        view.addSubview(detailView)
        
        detailView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.rightAnchor)
    }
    
    // MARK: Functions
    
    private func setView(transaction: Expense) {
        print(transaction)
    }
    
    @objc
    private func editTransaction() {
        guard transaction != nil else {
            alert(
                title: "Error",
                message: "Can't edit transaction",
                actionTitle: "Cancel")
            return
        }
        
        let vc = EditViewController()
        vc.onApply = { newTrans in
            self.viewModel.applyTransaction(newTrans: newTrans) { err in
                DispatchQueue.main.async {
                    if let err = err {
                        self.alert(
                            title: "Error",
                            message: err.localizedDescription,
                            actionTitle: "Cancel")
                    } else {
                        self.showSnackBar(
                            message: "Transaction updated successfully!",
                            actionText: "OK")
                    }
                }
            }
        }

        vc.transaction = transaction
        
        present(vc, animated: true)
    }
}
