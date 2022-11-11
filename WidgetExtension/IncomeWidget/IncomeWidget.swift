import SwiftUI
import WidgetKit

private struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let currentDate = Date()
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)

        guard let nextDate = nextDate else {
            return
        }

        let entries = [SimpleEntry(date: currentDate)]
        let timeline = Timeline(entries: entries, policy: .after(nextDate))
        completion(timeline)
    }
}

private struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct Bar: View {
    let percent: CGFloat
    let color: Color
    let width: CGFloat

    var body: some View {
        GeometryReader { proxy in
            Path { path in
                path.move(to: .init(x: proxy.size.width / 2, y: proxy.size.height))
                path.addLine(to: .init(x: proxy.size.width / 2, y: 0))
            }
            .trim(from: 0, to: self.percent)
            .stroke(lineWidth: self.width)
            .foregroundColor(self.color)
        }
    }
}

private struct IncomeWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("\(Int(income))")
                    .font(.callout)
                    .padding(.leading, 16)

                Spacer()

                Text("\(Int(expense))")
                    .font(.callout)
                    .padding(.trailing, 16)
            }

            HStack {
                Bar(percent: income / self.maxValue, color: .green, width: 20)
                Bar(percent: expense / self.maxValue, color: .red, width: 20)
            }
            .background(Color.pink.opacity(0.1))

            HStack {
                Text("Income")
                    .padding(.leading, 8)
                Spacer()
                Text("Expense")
                    .padding(.trailing, 8)
            }
        }
        .font(.footnote)
    }

    private var income: Double {
        UserDefaults.appGroup.double(forKey: UserDefaults.Keys.income.rawValue)
    }

    private var expense: Double {
        UserDefaults.appGroup.double(forKey: UserDefaults.Keys.expense.rawValue)
    }

    private var maxValue: Double {
        income > expense ? income : expense
    }

    private func getHeight(key: UserDefaults.Keys, height: Double) -> CGFloat {
        let max = income > expense ? income : expense

        if max == 0 {
            return height * 0.5
        }

        switch key {
        case .income:
            if income == 0 {
                return 0.1 * height
            }
            return (income / max) * height
        case .expense:
            if expense == 0 {
                return 0.1 * height
            }
            return (expense / max) * height
        }
    }
}

struct IncomeWidget: Widget {
    private let kind: String = WidgetKind.income

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            IncomeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Income/Expense Widget")
        .description("A widget show your monthly income/expense.")
        .supportedFamilies([.systemSmall])
    }
}
