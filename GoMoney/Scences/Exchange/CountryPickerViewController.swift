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
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupLayout() {
        super.setupLayout()

        view.addSubview(tableView)

        tableView.fillSuperview()
    }
}

extension CountryPickerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let country = countries[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel?.text = country.country
        cell.accessoryView = UIImageView(image: UIImage(named: country.country))
        cell.accessoryView?.bounds = CGRect(x: 0, y: 0, width: 30, height: 20)
        return cell
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return countries.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let country = countries[indexPath.row]
        onSelectCountry?(country)
        dismiss(animated: true)
    }
}
