
import UIKit

class OnboardCell: UICollectionViewCell {
    static let identifier = "onboard_cell"

    // MARK: - private properties

    private lazy var topicImage: UIImageView = .build { topicImage in
        topicImage.contentMode = .scaleAspectFill
        topicImage.layer.cornerRadius = 75
        topicImage.layer.masksToBounds = true
        topicImage.anchor(width: 200, height: 200)
    }

    private lazy var topicLabel: GMLabel = .init(style: .largeBold, isCenter: true)

    private lazy var descriptionLabel: GMLabel = .init(style: .regular, isCenter: true)

    private lazy var centerView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [topicImage, topicLabel])
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .center
        view.spacing = 16
        return view
    }()

    var page: OnboardPageModel? {
        didSet {
            topicImage.image = UIImage(named: page?.imageName ?? "")
            topicLabel.text = page?.topicText
            descriptionLabel.text = page?.descriptionText
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup layout

    private func setupLayout() {
        addSubviews(centerView, descriptionLabel)

        centerView.centerXToSuperview()
        centerView.centerYToSuperview(offset: -(windowSafeAreaInsets?.top ?? 0))

        descriptionLabel.centerXToSuperview()
        descriptionLabel.anchor(
            top: centerView.bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            paddingTop: 24,
            paddingLeft: 8,
            paddingRight: 8
        )
    }

    // MARK: public methods

    public func onWillAppear(_ view: UIView) {
        topicImage.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        descriptionLabel.transform = CGAffineTransform(translationX: view.frame.origin.x + view.frame.width / 2, y: 0)
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.topicImage.transform = .identity
            self.descriptionLabel.transform = .identity
        })
    }
}
