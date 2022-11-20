import Lottie
import UIKit

class EmptyTransactionView: UIView {
    // MARK: - Properties

    weak var vc: UIViewController?

    var label: String = "No Transaction Yet!" {
        didSet {
            noTransLabel.text = label
        }
    }

    var detailLabel: String = "After your first transaction you will be able to view it here" {
        didSet {
            noTransDetailLabel.text = detailLabel
        }
    }

    var animation: String = "empty" {
        didSet {
            emptyFace.animation = LottieAnimation.named(animation)
        }
    }

    // MARK: - Views

    private lazy var emptyFace: LottieAnimationView = .build {
        $0.animation = LottieAnimation.named(self.animation)
        $0.backgroundBehavior = .pauseAndRestore
        $0.loopMode = .loop
        $0.play()
    }

    private lazy var noTransLabel = GMLabel(
        text: label,
        style: .largeBold,
        isCenter: true
    )

    private lazy var noTransDetailLabel = GMLabel(
        text: detailLabel,
        style: .regular,
        isCenter: true
    ) {
        $0.numberOfLines = 0
    }

    private lazy var addButton = GMFloatingButton(
        image: UIImage(systemName: "plus.circle")?.color(.white),
        text: "Add",
        onTap: { [weak self] in
            self?.didTapAddTransaction()
        }
    )

    init(viewController: UIViewController) {
        super.init(frame: .zero)

        vc = viewController

        setupView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = K.Color.background
        addSubviews(emptyFace, noTransLabel, noTransDetailLabel, addButton)

        emptyFace.centerX(inView: self)
        emptyFace.anchor(bottom: noTransLabel.topAnchor, width: 300, height: 300)

        noTransLabel.centerY(inView: self)
        noTransLabel.anchor(
            left: leftAnchor,
            right: rightAnchor,
            paddingLeft: 24,
            paddingRight: 24
        )

        noTransDetailLabel.anchor(
            top: noTransLabel.bottomAnchor,
            left: noTransLabel.leftAnchor,
            right: noTransLabel.rightAnchor,
            paddingTop: 24
        )

        addButton.centerX(inView: self)
        addButton.anchor(
            bottom: bottomAnchor,
            paddingBottom: 24
        )
    }

    private func didTapAddTransaction() {
        guard let vc = vc else {
            return
        }

        let addExpenseVC = AddExpenseViewController()

        let expenseBtn = UIAlertAction(title: "And an Expense", style: .default) { _ in
            addExpenseVC.type = .expense
            vc.navigationController?.pushViewController(addExpenseVC, animated: true)
        }

        let incomeBtn = UIAlertAction(title: "Add an Income", style: .default) { _ in
            addExpenseVC.type = .income
            vc.navigationController?.pushViewController(addExpenseVC, animated: true)
        }

        vc.alert(
            type: .actionSheet,
            with: "GoMoney",
            message: "Add transaction",
            actions: [expenseBtn, incomeBtn]
        )
    }
}
