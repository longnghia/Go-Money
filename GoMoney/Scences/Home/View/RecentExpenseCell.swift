import UIKit

class RecentExpenseCell: UITableViewCell {
    static let identifier = "recent_expense_cell"

    var expense: Expense? {
        didSet {
            if let expense = expense {
                bindView(transaction: expense)
            }
        }
    }

    lazy var icon = GMExpenseIcon()
    lazy var labelName = GMLabel(style: .regularBold)
    lazy var labelDate = GMLabel(style: .small)
    lazy var labelPrice = GMLabel(style: .regularBold)
    lazy var labelNote = {
        let lbl = GMLabel(style: .small)
        lbl.textAlignment = .right
        return lbl
    }()

    lazy var stackInfo: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 4
        stackView.addArrangedSubviews(labelName, labelDate)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setView() {
        backgroundColor = K.Color.background
        addSubviews(icon, stackInfo, labelPrice, labelNote)

        icon.anchor(left: leftAnchor, paddingLeft: 4)
        icon.centerYToView(self)
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75),
            icon.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75),
        ])

        stackInfo.centerYToView(self)
        stackInfo.anchor(
            left: icon.rightAnchor,
            paddingLeft: 8
        )

        labelPrice.centerYToView(self)
        labelPrice.anchor(right: rightAnchor, paddingRight: 4)
        labelNote.anchor(top: labelPrice.bottomAnchor,
                         right: labelPrice.rightAnchor,
                         paddingTop: 4,
                         width: 100)
    }

    func bindView(transaction: Expense) {
        icon.loadIcon(src: transaction.tag?.icon)
        labelName.text = transaction.tag?.name
        labelDate.text = transaction.getDate(.occuredOn)
        let currency = SettingsManager.shared.getValue(for: .currencyUnit)
        labelPrice.text = "\(transaction.amount.formatWithCommas()) \(currency)"
        labelNote.text = transaction.note
        switch transaction.type {
        case ExpenseType.income.rawValue:
            labelPrice.textColor = K.Color.saving
        case ExpenseType.expense.rawValue:
            labelPrice.textColor = K.Color.debt
        default:
            break
        }
    }
}
