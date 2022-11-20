import UIKit

class GMExpenseIcon: UIView {
    var imageSrc: String? {
        didSet {
            loadIcon(src: imageSrc)
        }
    }

    lazy var icon: AsyncImageView = {
        let image = AsyncImageView()
        image.layer.cornerRadius = 4
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    init() {
        super.init(frame: .zero)
        setView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setView() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(icon)

        widthAnchor.constraint(equalTo: heightAnchor).isActive = true

        icon.centerInSuperview()
        icon.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        icon.widthAnchor.constraint(equalTo: icon.heightAnchor).isActive = true
        layer.cornerRadius = 8
    }

    func loadIcon(src: String?) {
        guard let src = src else {
            return
        }

        if src.isUrl() {
            if let url = URL(string: src) {
                icon.load(imageURL: url)
            }
        } else {
            icon.defaultImage = UIImage(named: src)
        }
    }
}

private extension String {
    func isUrl() -> Bool {
        starts(with: "http")
    }
}
