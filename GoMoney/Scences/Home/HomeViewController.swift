import Charts
import Floaty
import UIKit

class HomeViewController: GMMainViewController {
    // MARK: - Public Properties

    let viewModel = HomeViewModel()

    // MARK: - Private Properties

    private lazy var backImage: UIView = .build {
        $0.backgroundColor = .action
    }

    private lazy var chartView = ChartView()

    private lazy var recentExpenseLabel = GMLabel(text: Content.recentExpense, style: .regularBold)

    private lazy var viewAllLabel = GMButton(
        text: Content.viewAll,
        font: K.Font.nova,
        tapAction: { [weak self] in
            let vc = ViewAllViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    )

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RecentExpenseCell.self, forCellReuseIdentifier: RecentExpenseCell.identifier)
        tableView.backgroundColor = K.Color.background
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = Constant.rowHeight
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        return tableView
    }()

    private lazy var floatingButton: Floaty = {
        let floatingButton = Floaty()

        floatingButton.size = Constant.buttonSize
        floatingButton.itemSize = Constant.buttonSize
        floatingButton.plusColor = .white
        floatingButton.buttonColor = .action

        floatingButton.addItem("Income", icon: UIImage(named: "ic_add_income")?.color(K.Color.saving), titlePosition: .left) { [weak self] _ in
            self?.navigateToAddTransaction(type: .income)
            self?.floatingButton.close()
        }

        floatingButton.addItem("Expense", icon: UIImage(named: "ic_add_expense")?.color(K.Color.debt)) { [weak self] _ in
            self?.navigateToAddTransaction(type: .expense)
            self?.floatingButton.close()
        }

        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        return floatingButton
    }()

    private var emptyView: EmptyTransactionView?

    // MARK: - LyfeCircle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        chartView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        tableView.transform = CGAffineTransform(translationX: 10, y: 0)
        floatingButton.transform = CGAffineTransform(translationX: 0, y: 10)

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.chartView.transform = .identity
            self.tableView.transform = .identity
            self.floatingButton.transform = .identity
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        loadData()
        configureSyncInterval()
    }

    private func configureSyncInterval() {
        SyncManager.shared.setSyncInterval()
    }

    override func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(onDataChanged), name: .dataChanged, object: nil)
    }

    override func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: .dataChanged, object: nil)
    }

    // MARK: - Setup NavBar

    override func configureBackButton() {
        configureRootTitle(
            leftImage: K.Image.note,
            leftTitle: Content.myExpense,
            rightImage: K.Image.bell
        )
    }

    // MARK: - Setup layout

    override func setupLayout() {
        super.setupLayout()

        view.addSubviews(
            backImage,
            chartView,
            recentExpenseLabel,
            tableView,
            floatingButton,
            viewAllLabel
        )

        let chartSize = view.bounds.size.width - 2 * Constant.padding

        chartView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            paddingTop: Constant.chartPaddingTop,
            width: chartSize,
            height: chartSize * 2 / 3
        )
        chartView.centerX(inView: view)

        backImage.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            height: (chartSize * 2 / 3 + Constant.chartPaddingTop) / 2
        )

        recentExpenseLabel.anchor(
            top: chartView.bottomAnchor,
            left: chartView.leftAnchor,
            paddingTop: 16
        )

        viewAllLabel.anchor(
            top: recentExpenseLabel.topAnchor,
            right: chartView.rightAnchor
        )

        tableView.anchor(
            top: recentExpenseLabel.topAnchor,
            left: chartView.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: chartView.rightAnchor,
            paddingTop: 32
        )

        floatingButton.anchor(
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.rightAnchor,
            paddingRight: Constant.padding,
            width: Constant.buttonSize,
            height: Constant.buttonSize
        )
    }

    // MARK: Actions

    private func navigateToAddTransaction(type: ExpenseType) {
        let vc = AddExpenseViewController()
        vc.type = type
        navigationController?.pushViewController(vc, animated: true)
    }

    private func loadData() {
        viewModel.loadExpenses()
    }

    private func loadChartView() {
        chartView.setData(
            viewModel.groupedExpenses,
            incomeSum: viewModel.incomeSum,
            expenseSum: viewModel.expenseSum
        )

        chartView.saveImage()
    }

    // MARK: Methods

    @objc
    open func onDataChanged(notification: Notification) {
        guard notification.object as? UIViewController != self else {
            return
        }
        loadData()
    }
}

// MARK: - Table Delegate

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.transactions?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: RecentExpenseCell.identifier) as? RecentExpenseCell {
            if let expense = viewModel.transactions?[indexPath.row] {
                cell.selectionStyle = .none
                cell.expense = expense
                return cell
            }
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let transaction = viewModel.transactions?[indexPath.row] {
            let vc = DetailViewController()
            vc.transaction = transaction
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func tableView(_: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete") { _, _, completionHandler in
            completionHandler(true)
            if let transaction = self.viewModel.transactions?[indexPath.row] {
                self.alertDeleteTransaction(
                    transaction: transaction,
                    indexPath: indexPath,
                    handler: completionHandler
                )
            }
        }

        delete.image = UIImage(systemName: "trash")
        delete.backgroundColor = .red

        let swipe = UISwipeActionsConfiguration(actions: [delete])

        return swipe
    }

    func tableView(_: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { _, _, completionHandler in
            if let transaction = self.viewModel.transactions?[indexPath.row] {
                let vc = EditViewController()
                vc.transaction = transaction
                vc.onApply = { [weak self] newTrans in
                    self?.applyTransaction(transaction: transaction, newTrans: newTrans)
                }

                self.present(vc, animated: true)

                completionHandler(true)
            }
        }

        edit.image = UIImage(systemName: "highlighter")
        edit.backgroundColor = .green

        let swipe = UISwipeActionsConfiguration(actions: [edit])

        return swipe
    }

    private func applyTransaction(transaction: Expense, newTrans: Expense) {
        viewModel.applyTransaction(transaction: transaction, newTrans: newTrans) { [weak self] err in
            DispatchQueue.main.async {
                if let err = err {
                    self?.alert(
                        title: "Error",
                        message: err.localizedDescription,
                        actionTitle: "Cancel"
                    )
                } else {
                    self?.loadData()
                    self?.snackBar(
                        message: "Transaction updated successfully!",
                        actionText: "OK"
                    )
                }
            }
        }
    }

    private func toggleEmptyView() {
        let empty = viewModel.transactions?.count == 0
        let contents = [backImage, chartView, recentExpenseLabel, tableView, floatingButton]
        if empty {
            contents.forEach { $0.isHidden = true }
            emptyView = EmptyTransactionView(viewController: self)
            if let emptyView = emptyView {
                view.addSubview(emptyView)
                emptyView.fillSuperview()
            }
        } else {
            contents.forEach { $0.isHidden = false }
            emptyView?.removeFromSuperview()
            emptyView = nil
        }
    }
}

// MARK: - Alert

extension HomeViewController {
    func alertDeleteTransaction(transaction: Expense, indexPath: IndexPath, handler _: @escaping (Bool) -> Void) {
        let alert = UIAlertController(
            title: "Delete Transaction",
            message: "Are you sure to delete \(transaction.tag?.name ?? "transaction")?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in

            self.viewModel.deleteTransaction(transaction) { err in

                if let err = err {
                    self.alert(title: "Error", message: err.localizedDescription)
                } else {
                    self.notifyDataDidChange()
                    DispatchQueue.main.async { [weak self] in
                        // show empty if remove all transaction.
                        self?.toggleEmptyView()
                        self?.tableView.deleteRows(at: [indexPath], with: .left)
                        self?.loadChartView()
                    }
                }
            }
        })
        present(alert, animated: true)
    }
}

// MARK: - Content

extension HomeViewController {
    private enum Content {
        static let myExpense = "My Transactions"
        static let recentExpense = "Recent Transactions"
        static let viewAll = "View All"
    }

    private enum Constant {
        static let padding: CGFloat = 24
        static let chartPaddingTop: CGFloat = 8
        static let rowHeight: CGFloat = 65
        static let buttonSize: CGFloat = 36
    }
}

extension HomeViewController: DataServiceDelegate {
    func dataDidAdd() {}

    func dataDidUpdate() {}

    func dataDidRemove() {}

    func dataWillLoad() {
        GMLoadingView.shared.startLoadingAnimation()
    }

    func dataDidLoad() {
        DispatchQueue.main.async { [weak self] in
            self?.toggleEmptyView()
            GMLoadingView.shared.endLoadingAnimation()

            self?.tableView.reloadData()
            self?.loadChartView()
        }
    }
}
