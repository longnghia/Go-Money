import UIKit

class ExchangeCell: UITableViewCell {
    static let identifier = "exchange_cell"
    lazy var symbolLabel = GMLabel(style: .largeBold, isCenter: true)
    lazy var codeLabel = GMLabel(isCenter: true)
    lazy var rateLabel = GMLabel()
    lazy var amountLabel = GMLabel(style: .largeBold)

    lazy var flag: UIImageView = .build { _ in }

    lazy var stackSymbolAndCode = {
        let stackView = UIStackView(arrangedSubviews: [self.amountLabel, self.rateLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var stackAmountAndRate = {
        let stackView = UIStackView(arrangedSubviews: [self.symbolLabel, self.codeLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
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
        addSubviews(stackSymbolAndCode, stackAmountAndRate, flag)

        stackAmountAndRate.anchor(left: leftAnchor, width: 90)
        stackAmountAndRate.centerYToView(self)
        stackSymbolAndCode.anchor(left: stackAmountAndRate.rightAnchor, paddingLeft: 32)
        stackSymbolAndCode.centerYToView(self)
        flag.anchor(right: rightAnchor, paddingRight: 32, width: 25, height: 20)
        flag.centerYToView(self)
    }

    func bindView(with exchange: Exchange) {
        symbolLabel.text = exchange.to.symbol
        codeLabel.text = exchange.to.code
        amountLabel.text = String(format: "%.2f", exchange.amount * exchange.rate)

        let rate = String(format: "1 %@ = %.2f %@", exchange.from.code, exchange.rate, exchange.to.code)
        rateLabel.text = rate

        flag.image = UIImage(named: "\(exchange.to.country)")
    }
}
