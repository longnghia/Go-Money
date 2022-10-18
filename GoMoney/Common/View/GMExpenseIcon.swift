import UIKit

class GMExpenseIcon: UIView {
    lazy var icon: UIImageView = .build {
        $0.contentMode = .scaleAspectFill
    }

    init(image: UIImage? = UIImage(systemName: "fork.knife.circle")) {
        super.init(frame: .zero)
        icon.image = image
        setView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
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
}
