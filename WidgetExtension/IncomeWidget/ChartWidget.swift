import SwiftUI
import WidgetKit

public extension UIImage {
    static func loadFrom(url: URL, completion: @escaping (_ image: UIImage?) -> Void) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}

private struct Provider: TimelineProvider {
    let icon = UIImage(named: "ic_chart") ?? UIImage()
    func placeholder(in _: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), image: Image(uiImage: icon))
    }

    func getSnapshot(in _: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), image: Image(uiImage: icon))
        completion(entry)
    }

    func getTimeline(in _: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let currentDate = Date()
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)

        guard let nextDate = nextDate else {
            return
        }

        guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.kappa.expense")?.appendingPathComponent("chart.png") else {
            return
        }

        UIImage.loadFrom(url: url) { image in
            if let image = image {
                let date = Date()
                let img = Image(uiImage: image)

                let entry: SimpleEntry

                entry = SimpleEntry(
                    date: date,
                    image: img
                )

                let timeline = Timeline(
                    entries: [entry],
                    policy: .after(nextDate)
                )

                completion(timeline)

            } else {
                let entry = SimpleEntry(date: currentDate, image: Image(uiImage: icon))
                let timeline = Timeline(entries: [entry], policy: .atEnd)
                completion(timeline)
            }
        }
    }
}

private struct SimpleEntry: TimelineEntry {
    let date: Date
    let image: Image
}

private struct ChartWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            entry.image
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }
}

struct ChartWidget: Widget {
    private let kind: String = WidgetKind.chart

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ChartWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Chart Widget")
        .description("A pie chart show your expenses' percentages")
        .supportedFamilies([.systemSmall])
    }
}
