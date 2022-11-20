import UIKit

class IconPickerCell: UICollectionViewCell {
    static let identifier = "icon_picker_cell"

    lazy var image = GMExpenseIcon()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubviews(image)

        image.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75).isActive = true
        image.centerInSuperview()
    }

    func bindView(src: String) {
        image.loadIcon(src: src)
    }
}
