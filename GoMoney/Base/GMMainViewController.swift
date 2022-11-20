import Reachability
import UIKit

/// BaseMainViewController with colored navigationBar and colored Background
class GMMainViewController: GMViewController {
    var networkAvailable = true
    let reachability = try! Reachability()

    deinit {
        reachability.stopNotifier()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureReachability()
        startNotifier()
    }

    override func configureNavigation() {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: K.Theme.titleFont]

        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = .action
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

        configureBackButton()
    }

    override func configureBackButton() {
        let leftBarButtonImage = K.Image.close.withTintColor(.white, renderingMode: .alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftBarButtonImage,
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didTapBack))
        navigationController?.navigationBar.barTintColor = .white
    }

    func configureRootTitle(leftImage: UIImage? = nil, leftTitle: String? = nil, rightImage: UIImage? = nil) {
        if let leftBarImage =
            leftImage?.white(),
            let leftTitle = leftTitle
        {
            let leftBarIcon = UIBarButtonItem(
                image: leftBarImage,
                style: .done,
                target: self,
                action: nil
            )

            let leftBarTitle = UIBarButtonItem(
                title: leftTitle,
                style: .plain,
                target: self,
                action: nil
            )

            leftBarTitle.setTitleTextAttributes(
                [.foregroundColor: UIColor.white, .font: K.Theme.titleFont],
                for: .disabled
            )

            leftBarIcon.isEnabled = false
            leftBarTitle.isEnabled = false

            navigationItem.leftBarButtonItems = [leftBarIcon, leftBarTitle]
        }
        if let rightBarImage = rightImage?.white() {
            let rightBarIcon = UIBarButtonItem(
                image: rightBarImage,
                style: .done,
                target: self,
                action: nil
            )
            navigationItem.rightBarButtonItem = rightBarIcon
        }

        navigationController?.navigationBar.barTintColor = .white
    }

    func notifyDataDidChange() {
        NotificationCenter.default.post(name: .dataChanged, object: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability.stopNotifier()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startNotifier()
    }

    private func configureReachability() {
        reachability.whenReachable = { [weak self] _ in

            ConnectionService.shared.connection = self?.reachability.connection

            if self?.networkAvailable == false {
                self?.snackBar(
                    message: "Connection restored",
                    actionIcon: UIImage(named: "ic_wifi")?.color(.green)
                )
                self?.networkAvailable = true
            }
        }

        reachability.whenUnreachable = { [weak self] _ in

            ConnectionService.shared.connection = self?.reachability.connection

            self?.networkAvailable = false

            self?.snackBar(
                message: "Connection lost",
                actionIcon: UIImage(named: "ic_wifi_off")?.color(.red)
            )
        }
    }

    private func startNotifier() {
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}
