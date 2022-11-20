import Charts
import UIKit

class StatLineChartCell: UITableViewCell {
    static let identifier = "cell_line_chart"

    var dateType: ExpenseFilter = .week

    var expenses = [DateAmount]() {
        didSet {
            setLineChart()
        }
    }

    lazy var chartView: LineChartView = {
        let chartView = LineChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.backgroundColor = K.Color.background

        chartView.legend.enabled = false
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false

        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = false

        chartView.drawGridBackgroundEnabled = false
        chartView.chartDescription.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true

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

    private func setLineChart() {
        let entries = (0 ..< expenses.count).map { index -> ChartDataEntry in
            ChartDataEntry(x: Double(index), y: expenses[index].totalAmount)
        }

        let dataSet = LineChartDataSet(entries: entries, label: "")
        dataSet.drawIconsEnabled = false
        dataSet.isDrawLineWithGradientEnabled = true
        setup(dataSet)

        let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
                              K.Color.primaryColor.cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!

        dataSet.fillAlpha = 1
        dataSet.fill = LinearGradientFill(gradient: gradient, angle: 90)
        dataSet.drawFilledEnabled = true

        let data = LineChartData(dataSet: dataSet)

        chartView.animate(xAxisDuration: 0.4)
        chartView.xAxis.valueFormatter = LineChartXAxisFormatter(dateAmount: expenses, dateType: dateType)
        chartView.xAxis.labelCount = expenses.count - 1

        chartView.data = data
    }

    private func setup(_ dataSet: LineChartDataSet) {
        if dataSet.isDrawLineWithGradientEnabled {
            dataSet.lineDashLengths = nil
            dataSet.highlightLineDashLengths = nil
            dataSet.setColors(.black, .red, .white)
            dataSet.setCircleColor(.black)
            dataSet.gradientPositions = [0, 40, 100]
            dataSet.lineWidth = 1
            dataSet.circleRadius = 3
            dataSet.drawCircleHoleEnabled = false
            dataSet.valueFont = .systemFont(ofSize: 9)
            dataSet.formLineDashLengths = nil
            dataSet.formLineWidth = 1
            dataSet.formSize = 15
        } else {
            dataSet.lineDashLengths = [5, 2.5]
            dataSet.highlightLineDashLengths = [5, 2.5]
            dataSet.setColor(.black)
            dataSet.setCircleColor(.black)
            dataSet.gradientPositions = nil
            dataSet.lineWidth = 1
            dataSet.circleRadius = 3
            dataSet.drawCircleHoleEnabled = false
            dataSet.valueFont = .systemFont(ofSize: 9)
            dataSet.formLineDashLengths = [5, 2.5]
            dataSet.formLineWidth = 1
            dataSet.formSize = 15
        }
    }
}
