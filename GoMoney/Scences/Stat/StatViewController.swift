import DropDown
import UIKit

class StatViewController: GMMainViewController {
    // MARK: Properties

    private let sections = ["Expenses", "Category Expenses", "Top Expenses"]
    private let viewModel = StatViewModel()

    private lazy var tableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = K.Color.background

        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 16
        }

        tableView.register(StatLineChartCell.self, forCellReuseIdentifier: StatLineChartCell.identifier)
        tableView.register(StatBarChartCell.self, forCellReuseIdentifier: StatBarChartCell.identifier)
        tableView.register(RecentExpenseCell.self, forCellReuseIdentifier: RecentExpenseCell.identifier)

        tableView.dataSource = self
        tableView.delegate = self

        return tableView

    }()

    private lazy var dropDown: DropDown = .build { [self] dropDown in
        dropDown.dataSource = ExpenseFilter.allFilters.map { $0.getName() }
        dropDown.anchorView = filterBtn

        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.filterBtn.setTitle(item, for: .normal)
            self?.viewModel.filterBy = ExpenseFilter.allFilters[index]
        }
    }

    private lazy var filterBtn = GMButton(
        text: ExpenseFilter.week.getName(),
        tapAction: { [weak self] in
            self?.dropDown.show()
        }
    ) {
        $0.backgroundColor = .clear
    }

    private var emptyView: EmptyTransactionView?

    // MARK: - NavigationBar

    override func configureBackButton() {
        configureRootTitle(
            leftImage: K.Image.statistic,
            leftTitle: "Stats"
        )
    }

    // MARK: LifeCircle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }

    override func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(onDataChanged), name: .dataChanged, object: nil)
    }

    override func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: .dataChanged, object: nil)
    }

    // MARK: ViewModel

    func setupViewModel() {
        viewModel.didChangeFilter = { [weak self] in
            DispatchQueue.main.async {
                self?.toggleEmptyView()
                self?.tableView.reloadData()
            }
        }
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.transform = CGAffineTransform(translationX: -10, y: 0)
        filterBtn.transform = CGAffineTransform(translationX: 10, y: 0)

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.tableView.transform = .identity
            self.filterBtn.transform = .identity
        })
    }

    // MARK: Setup Layout

    override func setupLayout() {
        super.setupLayout()
        view.addSubviews(tableView, filterBtn)

        tableView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor,
            paddingLeft: Constant.padding,
            paddingRight: Constant.padding
        )

        filterBtn.anchor(
            top: tableView.topAnchor,
            right: tableView.rightAnchor,
            paddingTop: 28,
            width: 90
        )
    }

    // MARK: Methods

    private func loadData() {
        GMLoadingView.shared.startLoadingAnimation(with: "Loading data ...")
        viewModel.getFilteredExpense {
            DispatchQueue.main.async {
                GMLoadingView.shared.endLoadingAnimation()
            }
        }
    }

    @objc
    private func onDataChanged(notification: Notification) {
        guard notification.object as? UIViewController != self else {
            return
        }
        loadData()
    }

    private func toggleEmptyView() {
        let empty = viewModel.tagExpenses?.count == 0
        let contents = [tableView, filterBtn]
        if empty {
            contents.forEach { $0.isHidden = true }
            emptyView = EmptyTransactionView(viewController: self)
            if let emptyView = emptyView {
                emptyView.label = "No Expense Yet!"
                emptyView.detailLabel = "After your first expense you will be able to view it here"
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

// MARK: TableView DataSource

extension StatViewController: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return sections.count
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return viewModel.topExpenses?.count ?? 0
        }
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: StatLineChartCell.identifier, for: indexPath) as? StatLineChartCell {
                cell.dateType = viewModel.filterBy
                cell.expenses = viewModel.dateExpenses ?? []
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: StatBarChartCell.identifier, for: indexPath) as? StatBarChartCell {
                cell.tagExpenses = viewModel.tagExpenses ?? []
                return cell
            }
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: RecentExpenseCell.identifier, for: indexPath) as? RecentExpenseCell {
                if let expense = viewModel.topExpenses?[indexPath.row] {
                    cell.expense = expense
                    return cell
                }
            }
        default:
            break
        }
        return UITableViewCell()
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return Constant.chartHeight
        case 1:
            return Constant.chartHeight
        default:
            return Constant.cellHeight
        }
    }

    func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
}

// MARK: TableView Delegate

extension StatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 2 {
            if let transaction = viewModel.topExpenses?[indexPath.row] {
                let vc = DetailViewController()
                vc.transaction = transaction
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

// MARK: Constant

extension StatViewController {
    private enum Constant {
        static let padding: CGFloat = 16
        static let cellHeight: CGFloat = 65
        static let chartHeight = (UIScreen.main.bounds.width - 2 * padding) / 2
    }
}
