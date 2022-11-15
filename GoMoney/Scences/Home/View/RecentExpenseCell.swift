import UIKit

class RecentExpenseCell: UITableViewCell {
    static let identifier = "recent_expense_cell"

    var expense: Expense? {
        didSet {
            if let expense = expense {
                icon.loadIcon(src: expense.tag?.icon)
                labelName.text = expense.tag?.name
                labelDate.text = expense.getDate(.occuredOn)
                labelPrice.text = String(expense.amount)
            }
        }
    }

    lazy var icon = GMExpenseIcon()
    lazy var labelName = GMLabel(text: "Gas", style: .regularBold)
    lazy var labelDate = GMLabel(text: "20/10/2022", style: .small)
    lazy var labelPrice = GMLabel(style: .regularBold)

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
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setView() {
        backgroundColor = K.Color.background
        addSubviews(icon, stackInfo, labelPrice)

        icon.anchor(left: leftAnchor, paddingLeft: 4)
        icon.centerYToView(self)
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75),
            icon.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75)
        ])

        stackInfo.centerYToView(self)
        stackInfo.anchor(
            left: icon.rightAnchor,
            paddingLeft: 8
        )

        labelPrice.centerYToView(self)
        labelPrice.anchor(top: topAnchor, right: rightAnchor, paddingRight: 4)
    }
}
