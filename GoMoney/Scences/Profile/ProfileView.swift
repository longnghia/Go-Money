import UIKit

class ProfileView: UIView {
    private enum Constant {
        static let height: CGFloat = 40
    }

    lazy var avatar: AsyncImageView = {
        let image = AsyncImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        image.anchor(width: 40, height: 40)
        return image
    }()

    lazy var name: GMLabel = .init(style: .regularBold, isCenter: false)

    lazy var email: GMLabel = .init(style: .small, isCenter: false)

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
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bindUserData(user: GMUser) {
        name.text = user.name ?? "user_\(user.uid.prefix(4))"
        email.text = user.email
        avatar.load(imageURL: user.photoUrl, defaultImage: K.Image.user)
    }
}
