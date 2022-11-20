import Charts
import UIKit

class StatBarChartCell: UITableViewCell {
    static let identifier = "cell_bar_chart"

    var tagExpenses = [TagAmount]() {
        didSet {
            setBarChart()
        }
    }

    lazy var chartView: BarChartView = {
        let chartView = BarChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.gridBackgroundColor = K.Color.background
        chartView.backgroundColor = K.Color.background

        chartView.legend.enabled = false
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.drawMarkers = false

        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = false
        chartView.drawGridBackgroundEnabled = true

        chartView.maxVisibleCount = 60

        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .nova(10)
        xAxis.granularity = 1

        chartView.delegate = self

        return chartView

    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.backgroundColor = K.Color.background
        contentView.addSubview(chartView)

        chartView.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
    }

    private func setBarChart() {
        let entries = (0 ..< tagExpenses.count).map { index -> BarChartDataEntry in
            BarChartDataEntry(x: Double(index), y: tagExpenses[index].totalAmount)
        }

        let dataSet = BarChartDataSet(entries: entries, label: "")
        dataSet.drawIconsEnabled = false
        dataSet.colors = [.action]
        dataSet.barShadowColor = K.Color.contentBackground

        let data = BarChartData(dataSet: dataSet)
        data.barWidth = 0.1
        data.setDrawValues(false)

        chartView.xAxis.valueFormatter = BarChartXAxisFormatter(tagExpenses: tagExpenses)

        chartView.data = data
        chartView.animate(xAxisDuration: 0.4)
    }
}

extension StatBarChartCell: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry _: ChartDataEntry, highlight _: Highlight) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            chartView.highlightValue(nil)
        }
        // TODO: On bar tapped
    }
}
