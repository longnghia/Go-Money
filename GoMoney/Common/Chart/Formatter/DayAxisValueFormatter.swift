import Charts

class BarChartXAxisFormatter: IndexAxisValueFormatter {
    fileprivate var tagExpenses: [TagAmount]?

    convenience init(tagExpenses: [TagAmount]) {
        self.init()
        self.tagExpenses = tagExpenses
    }

    override func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let tagExpenses = tagExpenses, tagExpenses.count > 0, tagExpenses.count > Int(value) else {
            return ""
        }

        return tagExpenses[Int(value)].tag
    }
}
