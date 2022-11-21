import UIKit

class ViewAllViewController: GMMainViewController {
    let viewModel = ViewAllViewModel()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RecentExpenseCell.self, forCellReuseIdentifier: RecentExpenseCell.identifier)
        tableView.backgroundColor = K.Color.background
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = .rowHeight
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        return tableView
    }()

    // MARK: - LifeCircle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }

    override func getTitle() -> String? {
        return "All Transactions"
    }

    override func setupLayout() {
        super.setupLayout()
        view.addSubview(tableView)

        tableView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.rightAnchor,
            paddingTop: .padding,
            paddingLeft: .padding,
            paddingRight: .padding
        )
    }

    // MARK: - Methods

    private func setupViewModel() {
        GMLoadingView.shared.startLoadingAnimation(with: "Loading ...")
        viewModel.getAllTransaction { [weak self] in
            GMLoadingView.shared.endLoadingAnimation()
            self?.tableView.reloadData()
        }
    }
}

// MARK: - Table Delegate

extension ViewAllViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: RecentExpenseCell.identifier) as? RecentExpenseCell {
            let expense = viewModel.transactions[indexPath.row]
            cell.selectionStyle = .none
            cell.expense = expense
            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let transaction = viewModel.transactions[indexPath.row]
        let vc = DetailViewController()
        vc.transaction = transaction
        navigationController?.pushViewController(vc, animated: true)
    }
}

private extension CGFloat {
    static let rowHeight: CGFloat = 65
    static let padding: CGFloat = 16
}
