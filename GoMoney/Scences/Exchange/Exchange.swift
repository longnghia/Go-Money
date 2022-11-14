struct CurrencyItem {
    var currencyName: String
    var country: String
    var code: String
    var symbol: String
}

struct Exchange {
    let from: CurrencyItem
    let to: CurrencyItem
    let amount: Double
    let rate: Double
}
