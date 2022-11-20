import UIKit

class GMImageButton: UIView {
    lazy var imageView: UIImageView = .build { _ in }

    var didTapButton: (() -> Void)?

    var size: CGFloat!

    init(size: CGFloat = 36, image: UIImage?, tintColor: UIColor = .white, backgroundColor: UIColor = .action, padding: CGFloat = 12, didTapButton: (() -> Void)? = nil, builder: ((GMImageButton) -> Void)? = nil) {
        super.init(frame: .zero)

        self.backgroundColor = backgroundColor
        self.size = size
        self.didTapButton = didTapButton
        isUserInteractionEnabled = true
        addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(didTap))
        )

        imageView.image = image
        imageView.tintColor = tintColor
        imageView.anchor(width: size - padding, height: size - padding)

        setupView()
        builder?(self)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false

        anchor(width: size, height: size)
        addSubview(imageView)

        imageView.centerInSuperview()

        layer.cornerRadius = size / 2
    }

    @objc
    private func didTap() {
        showTapAnimation {
            self.didTapButton?()
        }
    }
}
