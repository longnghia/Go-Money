import Foundation

class ExchangeViewModel {
    let service = ExchangeService()

    /// rates on USD
    var rates = [String: Double]()
    var currentBase: CurrencyItem?
    var exchanges = [Exchange]()
    var currencyList = [CurrencyItem]()

    /// 1 USD  =  xVND = yYEN
    /// => VND =y/x YEN
    func calculateRate(from: CurrencyItem, to: CurrencyItem) -> Double {
        let usdRateFrom = rates[from.code]
        let usdRateTo = rates[to.code]

        guard let usdRateFrom = usdRateFrom,
              let usdRateTo = usdRateTo,
              usdRateTo > 0
        else {
            return 0
        }

        return usdRateTo / usdRateFrom
    }

    func exchange(amount: Double, completion: @escaping () -> Void) {
        guard let base = currentBase else {
            return
        }

        exchanges = currencyList.map { target in
            let rate = calculateRate(from: base, to: target)
            return Exchange(from: base, to: target, amount: amount, rate: rate)
        }

        completion()
    }

    func setup(completion: @escaping (Error?) -> Void) {
        DispatchQueue.global().async {
            self.setupCountryData()

            let usd = CurrencyItem(currencyName: "dolar", country: "USA", code: "USD", symbol: "$")

            self.getLastestRate(from: usd) { err in
                completion(err)
            }
        }
    }

    func getLastestRate(from: CurrencyItem, completion: @escaping (Error?) -> Void) {
        service.getExchangeRate(from: from.code, to: [.dollar], completion: { result in
            switch result {
            case let .failure(error):
                completion(error)
            case let .success(exchange):
                let rates = exchange.rates

                self.rates = rates

                completion(nil)
            }

        })
    }

    private func setupCountryData() {
        let mainBundle = Bundle.main
        let path = mainBundle.url(forResource: "CountryData", withExtension: "plist")

        guard let path = path else {
            return
        }

        if let array = NSArray(contentsOf: path) {
            for currency in array {
                if let object = currency as? [String: Any] {
                    guard
                        let name = object["name"] as? String,
                        let country = object["country"] as? String,
                        let code = object["code"] as? String,
                        let symbol = object["symbol"] as? String
                    else {
                        return
                    }

                    let item = CurrencyItem(
                        currencyName: name,
                        country: country,
                        code: code,
                        symbol: symbol
                    )
                    currencyList.append(item)
                }
            }

            currentBase = currencyList
                .first(where: { $0.code == "USD" })
        }
    }
}
