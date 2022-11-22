import WidgetKit

class WidgetService {
    func updateIncomeWidget(income: Double, expense: Double) {
        UserDefaults.appGroup.set(income, forKey: UserDefaults.Keys.income.rawValue)
        UserDefaults.appGroup.set(expense, forKey: UserDefaults.Keys.expense.rawValue)
        WidgetCenter.shared.reloadTimelines(ofKind: WidgetKind.income)
    }

    func updateChartWidget() {
        WidgetCenter.shared.reloadTimelines(ofKind: WidgetKind.chart)
    }
}
