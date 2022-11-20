import Lottie
import UIKit

class BioLockViewController: UIViewController {
    // MARK: - Views

    lazy var logo: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var lockLabel = GMLabel(text: "GoMoney is locked", isCenter: true)

    lazy var unlockButton = GMFloatingButton(
        image: UIImage(systemName: "lock.circle"),
        text: "Unlock",
        textColor: .blue,
        background: .white,
        onTap: { [weak self] in
            self?.authenticate()
        }
    )

    // MARK: - LifeCircle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = K.Color.background

        setupLayout()
    }

    private func setupLayout() {
        view.addSubviews(logo, lockLabel, unlockButton)

        logo.centerInSuperview(size: CGSize(width: 100, height: 100))
        lockLabel.anchor(
            top: logo.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 16,
            paddingLeft: 16,
            paddingRight: 16
        )

        unlockButton.anchor(
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.rightAnchor,
            paddingRight: 16
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authenticate()
    }

    private func authenticate() {
        BiometricService.shared.authenticate { [weak self] error in
            if let error = error {
                switch error {
                case .biometryNotEnrolled:
                    self?.showGotoSettingsAlert(message: error.message())
                case .canceledBySystem, .canceledByUser:
                    break
                default:
                    print(error)
                    print(error.message())
                    self?.errorAlert(message: error.message())
                }
            } else {
                let tabBarVC = GMTabBarViewController()
//                tabBarVC.selectedIndex = 1
                if let delegate = self?.view.window?.windowScene?.delegate as? SceneDelegate {
                    delegate.window?.rootViewController = tabBarVC
                }
            }
        }
    }
}
