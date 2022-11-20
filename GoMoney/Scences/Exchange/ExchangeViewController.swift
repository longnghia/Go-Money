import Foundation
import UIKit

class ExchangeViewController: GMMainViewController {
    let viewModel = ExchangeViewModel()

    lazy var accessoryView = AccessoryView("Select Amount", doneTapped: { [weak self] in
        self?.textFieldDidChange()
        self?.textField.resignFirstResponder()
    })

    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.rightView = self.flagButton
        textField.font = .novaBold(32)
        textField.textAlignment = .center
        textField.keyboardType = .numberPad

        textField.rightView?.bounds = CGRect(x: 0, y: 0, width: 30, height: 20)
        textField.rightViewMode = .always

        textField.leftView = symbolLabel
        textField.leftViewMode = .always

        textField.inputAccessoryView = self.accessoryView

        return textField
    }()

    lazy var symbolLabel = GMLabel(style: .large)

    lazy var flagButton = GMButton(tapAction: { [weak self] in
        self?.openCountryPicker()
    }) {
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
    }

    lazy var tableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ExchangeCell.self, forCellReuseIdentifier: ExchangeCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false

        return tableView
    }()

    // MARK: - LyfeCircle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewModel()
    }

    private func setupViewModel() {
        GMLoadingView.shared.startLoadingAnimation(with: "Fetching latest exchange rates ...")
        viewModel.setup { [weak self] err in

            if let err = err {
                DispatchQueue.main.async {
                    GMLoadingView.shared.endLoadingAnimation()
                    self?.snackBar(message: "\(err.localizedDescription)")
                }
                return
            }

            if let base = self?.viewModel.currentBase {
                DispatchQueue.main.async {
                    self?.flagButton.setImage(UIImage(named: base.country), for: .normal)
                    self?.symbolLabel.text = base.symbol
                    self?.textField.text = "1"
                    self?.textField.becomeFirstResponder()
                }
            }

            self?.viewModel.exchange(amount: 1) {
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    GMLoadingView.shared.endLoadingAnimation()
                }
            }
        }
    }

    override func setupLayout() {
        super.setupLayout()

        view.addSubviews(textField, tableView)

        textField.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 16,
            paddingLeft: 16,
            paddingRight: 16,
            height: 65
        )

        tableView.anchor(
            top: textField.bottomAnchor,
            left: view.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.rightAnchor,
            paddingTop: 16,
            paddingLeft: 16,
            paddingBottom: 16,
            paddingRight: 16
        )
    }

    // MARK: - Actions

    @objc
    private func textFieldDidChange() {
        guard
            let text = textField.text,
            let amount = Double(text)
        else {
            return
        }

        viewModel.exchange(amount: amount, completion: { [weak self] in
            self?.tableView.reloadData()
        })
    }

    private func openCountryPicker() {
        let picker = CountryPickerViewController(
            countries: viewModel.currencyList,
            onSelectCountry: { [weak self] country in
                self?.flagButton.setImage(UIImage(named: country.country), for: .normal)
                self?.symbolLabel.text = country.symbol
                self?.viewModel.currentBase = country
            }
        )
        present(picker, animated: true)
    }
}

extension ExchangeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.exchanges.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeCell.identifier, for: indexPath) as? ExchangeCell
        {
            let exchange = viewModel.exchanges[indexPath.row]
            cell.bindView(with: exchange)
            return cell
        }

        return UITableViewCell()
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 72
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
