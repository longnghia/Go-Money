import UIKit

class ChartView: UIView {
    init() {
        super.init(frame: .zero)
        setView()
    }

    private func setView() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        addDropShadow()
        layer.cornerRadius = 16
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
