
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
            update()
        }
    }

    private func update() {
        font = UIFont(name: gmStyle.getFont(), size: gmStyle.getSize())
        textColor = gmStyle.getColor()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(
        text: String = "",
        style: GMLabelStyle = .regular,
        numberOfLines _: Int = 0,
        isCenter: Bool = false,
        builder: ((GMLabel) -> Void)? = nil
    ) {
        super.init(frame: .zero)

        self.text = text
        textAlignment = isCenter ? .center : .natural
        gmStyle = style

        setup()
        update()
        builder?(self)
    }

    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}
