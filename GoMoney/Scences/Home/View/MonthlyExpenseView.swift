import UIKit

class MonthlyExpenseView: UIView {
    lazy var label = GMLabel(style: .small, isCenter: true)
    lazy var amount = GMLabel(style: .regularBold) {
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
    required init?(coder _: NSCoder) {
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
