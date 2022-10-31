
import UIKit

enum GMLabelStyle {
    case small
    case regular
    case large
    case smallBold
    case regularBold
    case largeBold

    func getSize() -> CGFloat {
        switch self {
        case .small,
             .smallBold:
            return 12

        case .regular, .regularBold:
            return 16
        case .large, .largeBold:
            return 24
        }
    }

    func getFont() -> String {
        switch self {
        case .small, .regular, .large:
            return K.Font.nova
        case .smallBold, .regularBold, .largeBold:
            return K.Font.novaBold
        }
    }

    func getColor() -> UIColor {
        switch self {
        case .small, .smallBold:
            return .gray
        default:
            return .black
        }
    }
}

class GMLabel: UILabel {
    var gmStyle: GMLabelStyle = .regular {
        didSet {
            self.update()
        }
    }

    private func update() {
        self.font = UIFont(name: self.gmStyle.getFont(), size: self.gmStyle.getSize())
        self.textColor = self.gmStyle.getColor()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(
        text: String = "",
        style: GMLabelStyle = .regular,
        numberOfLines: Int = 0,
        isCenter: Bool = false,
        builder: ((GMLabel) -> Void)? = nil
    ) {
        super.init(frame: .zero)

        self.text = text
        self.textAlignment = isCenter ? .center : .natural
        self.gmStyle = style

        self.setup()
        self.update()
        builder?(self)
    }

    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}
