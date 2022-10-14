import UIKit

class ProfileViewController: GMViewController {
    private enum Constant {
        static let padding: CGFloat = 16
    }

    private enum Content {
        static let title = "Profile"
        static let notification = "Notifications"
        static let settings = "Settings"
        static let aboutUs = "About Us"
        static let help = "Help & Support"
    }

    private lazy var actionNotification: GMLabelAction = .init(
        text: Content.notification,
        icLeft: "bell")

    private lazy var actionSettings: GMLabelAction = .init(
        text: Content.settings,
        icLeft: "gearshape")

    private lazy var actionAbout: GMLabelAction = .init(
        text: Content.aboutUs,
        icLeft: "info.circle")

    private lazy var actionHelp: GMLabelAction = .init(
        text: Content.help,
        icLeft: "questionmark.circle")

    private lazy var stackActions: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubviews(actionNotification, actionNotification, actionAbout, actionHelp)
        return stackView
    }()

    override func setupLayout() {
        super.setupLayout()
        title = Content.title
        view.backgroundColor = .blue

        view.addSubviews(stackActions)

        stackActions.anchor(
            top: topAnchor,
            left: leftAnchor,
            right: rightAnchor,
            paddingLeft: Constant.padding,
            paddingRight: Constant.padding)
    }
}
