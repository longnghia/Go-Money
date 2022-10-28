import Charts
import Floaty
import UIKit

class HomeViewController: GMMainViewController {
    // MARK: - Public Properties

    let viewModel = HomeViewModel()

    // MARK: - Private Properties

    private lazy var backImage: UIView = .build {
        $0.backgroundColor = K.Color.actionBackground
    }

    private lazy var chartView = ChartView()

    private lazy var recentExpenseLabel = GMLabel(text: Content.recentExpense, style: .regularBold)

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
        floatingButton.buttonColor = K.Color.actionBackground

        floatingButton.addItem("Add Income", icon: UIImage(named: "ic_add_income")?.color(K.Color.saving), titlePosition: .left) { [weak self] _ in
            self?.navigateToAddTransaction(type: .income)
            self?.floatingButton.close()
        }

        floatingButton.addItem("Add Expense", icon: UIImage(named: "ic_add_expense")?.color(K.Color.debt)) { [weak self] _ in
            self?.navigateToAddTransaction(type: .expense)
            self?.floatingButton.close()
        }

        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        return floatingButton
    }()

    // MARK: - LyfeCircle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.loadExpenses()
    }

    // MARK: - Setup NavBar

    override func configureBackButton() {
        configureRootTitle(
            leftImage: K.Image.note,
            leftTitle: Content.myExpense,
            rightImage: K.Image.bell)
    }

    // MARK: - Setup layout

    override func setupLayout() {
        super.setupLayout()

        view.addSubviews(backImage, chartView, recentExpenseLabel, tableView, floatingButton)

        let chartSize = view.bounds.size.width - 2 * Constant.padding

        chartView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            paddingTop: Constant.chartPaddingTop,
            width: chartSize,
            height: chartSize * 2 / 3)
        chartView.centerX(inView: view)

        backImage.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            height: (chartSize * 2 / 3 + Constant.chartPaddingTop) / 2)

        recentExpenseLabel.anchor(
            top: chartView.bottomAnchor,
            left: chartView.leftAnchor,
            paddingTop: 16)

        tableView.anchor(
            top: recentExpenseLabel.topAnchor,
            left: chartView.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: chartView.rightAnchor,
            paddingTop: 32)

        floatingButton.anchor(
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.rightAnchor,
            paddingRight: Constant.padding,
            width: Constant.buttonSize,
            height: Constant.buttonSize)
    }

    // MARK: Actions

    private func navigateToAddTransaction(type: ExpenseType) {
        let vc = AddExpenseViewController()
        vc.type = type
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Table Delegate

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.expenses?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: RecentExpenseCell.identifier) as? RecentExpenseCell {
            if let expense = viewModel.expenses?[indexPath.row] {
                cell.expense = expense
                return cell
            }
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // TODO: go to detail
    }
}

// MARK: - Content

extension HomeViewController {
    private enum Content {
        static let myExpense = "My Expenses"
        static let recentExpense = "Recent Expenses"
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
            GMLoadingView.shared.endLoadingAnimation()

            self?.tableView.reloadData()
            self?.chartView.setData(
                self?.viewModel.expenses,
                incomeSum: self?.viewModel.incomeSum,
                expenseSum: self?.viewModel.expenseSum)
        }
    }
}
