import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    let settingManager = SettingsManager.shared

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScence = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScence.coordinateSpace.bounds)
        window?.windowScene = windowScence

        let onboarded = UserDefaults.standard.bool(forKey: UserDefaultKey.firstLaunch)

        // onboard showed
        if onboarded {
            // user signed in
            if UserDefaults.standard.string(forKey: "userId") != nil {
                // biometric lock
                let locked = SettingsManager.shared.getValue(for: .enablePassword) as? Bool ?? false
                if locked {
                    window?.rootViewController = BioLockViewController()
                } else {
                    let tabBarVC = GMTabBarViewController()
                    window?.rootViewController = tabBarVC
                }
            } else {
                let navVC = UINavigationController(rootViewController: SignInViewController())
                window?.rootViewController = navVC
            }
        } else {
            window?.rootViewController = OnboardViewController()
        }
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
