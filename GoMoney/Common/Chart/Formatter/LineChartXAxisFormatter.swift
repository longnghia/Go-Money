import Charts

class LineChartXAxisFormatter: IndexAxisValueFormatter {
    fileprivate var dateAmount: [DateAmount]?
    fileprivate var dateType: ExpenseFilter?

    convenience init(dateAmount: [DateAmount], dateType: ExpenseFilter) {
        self.init()
        self.dateAmount = dateAmount
        self.dateType = dateType
    }

    override func stringForValue(_ value: Double, axis _: AxisBase?) -> String {
        guard
            let dateAmount = dateAmount,
            let dateType = dateType,
            dateAmount.count > 0,
            dateAmount.count > Int(value),
            value >= 0
        else {
            return ""
        }

        let date = dateAmount[Int(value)].date

        switch dateType {
        case .week:
            return DateFormatter.eee.string(from: date)
        case .month:
            return DateFormatter.dd.string(from: date)
        case .year:
            return DateFormatter.mmm.string(from: date)
        case .all:
            return ""
        }
    }
}
