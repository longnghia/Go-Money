import Charts
import UIKit

class ChartView: UIView {
    lazy var pieChartView: PieChartView = .build {
        $0.drawEntryLabelsEnabled = false
    }

    lazy var monthlyExpenses = MonthlyExpenseView(text: "Monthly Expenses")
    lazy var monthlyIncomes = MonthlyExpenseView(text: "Monthly Incomes")
    lazy var monthlySavings = MonthlyExpenseView(text: "Monthly Savings")

    lazy var monthlyStackView: UIStackView = .build { [self] in
        $0.spacing = 64
        $0.axis = .vertical
        $0.addArrangedSubviews(monthlyIncomes, monthlySavings, monthlyExpenses)
    }

    init() {
        super.init(frame: .zero)
        setView()
    }

    private func setView() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        addDropShadow()
        layer.cornerRadius = 16

        addSubviews(pieChartView, monthlyStackView)

        NSLayoutConstraint.activate([
            pieChartView.topAnchor.constraint(equalTo: topAnchor),
            pieChartView.leftAnchor.constraint(equalTo: leftAnchor),
            pieChartView.widthAnchor.constraint(equalTo: heightAnchor),
            pieChartView.heightAnchor.constraint(equalTo: pieChartView.widthAnchor),
        ])

        monthlyStackView.anchor(
            top: topAnchor,
            left: pieChartView.rightAnchor,
            right: rightAnchor,
            paddingTop: 16,
            paddingRight: 16
        )
    }

    func setData(_ expenses: [TagAmount]?, incomeSum: Double?, expenseSum: Double?) {
        guard let expenses = expenses else {
            return
        }
        let sum: Double = expenses.reduce(0) { $0 + $1.totalAmount }
        let entries = expenses.map { expense in
            PieChartDataEntry(
                value: expense.totalAmount / sum * 100,
                label: expense.tag,
                icon: nil
            )
        }
        let set = PieChartDataSet(entries: entries, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        set.yValuePosition = PieChartDataSet.ValuePosition.outsideSlice

        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [.primary]

        let data = PieChartData(dataSet: set)

        data.setValueFont(.novaBold(11))
        data.setValueTextColor(.black)

        pieChartView.data = data

        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))

        if let incomeSum = incomeSum,
           let expenseSum = expenseSum
        {
            let savings = incomeSum - expenseSum

            guard
                let currency = SettingsManager.shared.getValue(for: .currencyUnit) as? String,
                let unit = CurrencyUnit(rawValue: currency)
            else {
                return
            }

            monthlyIncomes.amount.text =
                "\(MoneyFormatter.formatShorter(amount: incomeSum, currency: unit)) \(currency)"
            monthlyExpenses.amount.text =
                "\(MoneyFormatter.formatShorter(amount: expenseSum, currency: unit)) \(currency)"
            monthlySavings.amount.text =
                "\(MoneyFormatter.formatShorter(amount: savings, currency: unit)) \(currency)"

            if savings >= 0 {
                monthlySavings.amount.textColor = K.Color.saving
            } else {
                monthlySavings.amount.textColor = K.Color.debt
            }
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func saveImage() {
        let image = pieChartView.getChartImage(transparent: false)

        guard
            let image = image,
            let data = image.jpegData(compressionQuality: 1) ?? image.pngData()
        else {
            return
        }
        guard let directory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.kappa.expense")?.appendingPathComponent("chart.png") as? URL else {
            return
        }
        do {
            try data.write(to: directory)
        } catch {
            print(error.localizedDescription)
        }
    }
}
