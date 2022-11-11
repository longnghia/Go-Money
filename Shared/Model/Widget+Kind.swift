import Foundation

enum WidgetKind {
    static var income: String { widgetKind(#function) }
    static var chart: String { widgetKind(#function) }

    private static func widgetKind(_ kind: String) -> String {
        kind + "Widget"
    }
}
