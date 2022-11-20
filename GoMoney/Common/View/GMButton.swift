import UIKit

class GMButton: UIButton {
    private(set) var tapAction: (() -> Void)?

    convenience init(
        text: String = "",
        size: CGFloat = 16,
        color: UIColor = .black,
        font: String = K.Font.novaBold,
        tapAction: (() -> Void)? = nil,
        builder: ((GMButton) -> Void)? = nil
    ) {
        self.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(text, for: .normal)
        titleLabel?.textAlignment = .center
        setTitleColor(color, for: .normal)
        titleLabel?.font = UIFont(name: font, size: size)
        self.tapAction = tapAction
        addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        builder?(self)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @objc
    private func didTapButton() {
        tapAction?()
    }
}
