import UIKit

private class DetailCell: UIView {
    var value: String? {
        didSet {
            valueLabel.text = value
        }
    }

    lazy var keyLabel = GMLabel(style: .regularBold) {
        $0.textColor = K.Color.subTitle
    }

    lazy var valueLabel = GMLabel(style: .regular)

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.addArrangedSubviews(keyLabel, valueLabel)
        return stackView
    }()

    init(key: String = "", value: String = "") {
        super.init(frame: .zero)
        setDetail(key: key, value: value)
        setView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor)
    }

    func setDetail(key: String, value: String) {
        keyLabel.text = key
        valueLabel.text = value
    }
}

class DetailView: UIView {
    var transaction: Expense? {
        didSet {
            setDetail()
        }
    }

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()

    lazy var scrollView: UIScrollView = .build {
        $0.addSubview(self.stackView)
    }

    init(transaction: Expense?) {
        super.init(frame: .zero)

        self.transaction = transaction
        setView()
        setDetail()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setView() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(scrollView)

        scrollView.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor)

        stackView.anchor(
            top: scrollView.topAnchor,
            left: scrollView.leftAnchor,
            bottom: scrollView.bottomAnchor,
            right: scrollView.rightAnchor)
    }

    private func setDetail() {
        guard let transaction = transaction else {
            return
        }

        // remove all subviews when set new transaction
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        stackView.addArrangedSubviews(
            DetailCell(key: "Transaction type", value: transaction.type),
            DetailCell(key: "Tag", value: transaction.tag),
            DetailCell(key: "Amount", value: String(transaction.amount)),
            DetailCell(key: "When", value: DateFormatter.ddmmyyyy.string(from: transaction.occuredOn)),
            DetailCell(key: "Note", value: transaction.note))

        if let createdAt = transaction.createdAt {
            stackView.addArrangedSubview(
                DetailCell(key: "Created At", value: DateFormatter.date.string(from: createdAt)))
        }

        if let updatedAt = transaction.updatedAt {
            stackView.addArrangedSubview(
                DetailCell(key: "Updated At", value: DateFormatter.date.string(from: updatedAt)))
        }
    }
}