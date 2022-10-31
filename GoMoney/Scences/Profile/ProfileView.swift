import UIKit

class ProfileView: UIView {
    private enum Constant {
        static let height: CGFloat = 40
    }

    lazy var avatar: GMCircleImage = .init(size: Constant.height)

    lazy var name: GMLabel = .init(style: .regularBold, isCenter: true)

    lazy var email: GMLabel = .init(style: .small, isCenter: true)

    private lazy var stackNameEmail: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.addArrangedSubviews(name, email)
        return stackView
    }()

    private lazy var stackAll: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.addArrangedSubviews(avatar, stackNameEmail)
        return stackView
    }()

    init() {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        anchor(height: Constant.height)
        addSubviews(stackAll)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
