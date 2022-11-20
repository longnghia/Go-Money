import UIKit

class StatTableCell: UITableViewCell {
    static let identifier = "cell_table"

    var expenses = [Expense]() {
        didSet {
            tableView.reloadData()
        }
    }

    lazy var tableView: UITableView = .build {
        $0.register(RecentExpenseCell.self, forCellReuseIdentifier: RecentExpenseCell.identifier)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(tableView)
        tableView.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
    }
}

extension StatTableCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return expenses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: RecentExpenseCell.identifier) as? RecentExpenseCell {
            let expense = expenses[indexPath.row]
            cell.expense = expense
            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // TODO: go to detail
    }
}
