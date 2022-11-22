import SwiftUI
import WidgetKit

@main
struct GMWidgetBundle: WidgetBundle {
    var body: some Widget {
        WidgetBundle1().body
    }
}

struct WidgetBundle1: WidgetBundle {
    var body: some Widget {
        IncomeWidget()
        ChartWidget()
    }
}
