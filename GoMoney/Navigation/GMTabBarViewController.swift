import UIKit

class GMTabBarViewController: UITabBarController {
    private lazy var customTabBar: RollingPitTabBar = {
        let tabBar = RollingPitTabBar()
        tabBar.barBackColor = K.Color.white
        tabBar.barHeight = 65
        tabBar.circleBackColor = .red
        tabBar.circleRadius = 35
        tabBar.outerCircleRadius = 0
        tabBar.pitCircleDistanceOffset = 10
        tabBar.pathMoveDuration = 0.3
        tabBar.animateShowAndHideItemDuration = 0.2
        tabBar.marginLeft = 0
        tabBar.marginRight = 0
        tabBar.marginBottom = 0
        return tabBar
    }()

    // MARK: - TabBar Icon

    private let statBlackIcon = K.Image.statistic.black()
    private let statWhiteIcon = K.Image.statistic.white()
    private let homeBlackIcon = K.Image.dashboard.black()
    private let homeWhiteIcon = K.Image.dashboard.white()
    private let profileBlackIcon = K.Image.profile.black()
    private let profileWhiteIcon = K.Image.profile.white()

    // MARK: - LifeCircle

    override func viewDidLoad() {
        super.viewDidLoad()

        let statisticVC = MainNavigationController(rootViewController: StatViewController())
        statisticVC.tabBarItem = UITabBarItem(
            title: "",
            image: statBlackIcon,
            selectedImage: statWhiteIcon
        )

        let homeVC = MainNavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem = UITabBarItem(
            title: "",
            image: homeBlackIcon,
            selectedImage: homeWhiteIcon
        )

        let profileVC = MainNavigationController(rootViewController: ProfileViewController())
        profileVC.tabBarItem = UITabBarItem(
            title: "",
            image: profileBlackIcon,
            selectedImage: profileWhiteIcon
        )

        setValue(customTabBar, forKey: "tabBar")

        viewControllers = [statisticVC, homeVC, profileVC]

        selectedIndex = 1
    }
}
