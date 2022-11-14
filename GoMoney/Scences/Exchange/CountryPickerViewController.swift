import UIKit

class CountryPickerViewController: GMMainViewController {
    lazy var tableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ExchangeCell.self, forCellReuseIdentifier: ExchangeCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false

        return tableView
    }()

    var countries: [CurrencyItem]!
    var onSelectCountry: ((CurrencyItem) -> Void)?

    init(countries: [CurrencyItem],
         onSelectCountry: @escaping (CurrencyItem) -> Void)
    {
        super.init(nibName: nil, bundle: nil)

        self.countries = countries
        self.onSelectCountry = onSelectCountry
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupLayout() {
        super.setupLayout()

        view.addSubview(tableView)

        tableView.fillSuperview()
    }
}

extension CountryPickerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let country = countries[indexPath.row]
        let cell = UITableViewCell()
        cell.bindData(country: country)
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let country = countries[indexPath.row]
        onSelectCountry?(country)
        dismiss(animated: true)
    }
}

private extension UITableViewCell {
    func bindData(country: CurrencyItem) {
        textLabel?.text = country.country
        accessoryView = UIImageView(image: UIImage(named: country.country))
        accessoryView?.bounds = CGRect(x: 0, y: 0, width: 30, height: 20)
    }
}
