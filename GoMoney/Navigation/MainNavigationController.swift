import UIKit

class MainNavigationController: UINavigationController {
    /// Set light statusBar icons on dark navigationBar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
