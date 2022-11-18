import UIKit

class MoneyFormatter {
    static func formatShorter(amount: Double, currency: CurrencyUnit) -> String {
        switch currency {
        case .dong:
            switch amount {
            case 1 ..< 1_000_000:
                return amount.formatWithCommas()
            default:
                let million = amount / 1_000_000
                let formated = million.formatWithCommas(minFraction: 2, maxFraction: 2)
                return "\(formated)tr"
            }

        default:
            return String(amount.formatWithCommas())
        }
    }
}

class MonthlyExpenseView: UIView {
    lazy var label = GMLabel(style: .small)
    lazy var amount = GMLabel(style: .largeBold) {
        $0.textAlignment = .right
    }

    lazy var stackView: UIStackView = .build { [self] in
        $0.axis = .vertical
        $0.spacing = 8
        $0.addArrangedSubviews(label, amount)
    }

    init(text: String = "", amount: Double = 0, builder: ((MonthlyExpenseView) -> Void)? = nil) {
        super.init(frame: .zero)
        label.text = text
        self.amount.text = String(amount)
        setView()
        builder?(self)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.anchor(
            top: topAnchor,
            left: leftAnchor,
            right: rightAnchor
        )
    }
}
