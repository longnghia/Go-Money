import TTGSnackbar
import UIKit

extension UIViewController {
    func alert(type: UIAlertController.Style, with title: String?, message: String?, actions: [UIAlertAction], showCancel: Bool = true) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: type)

        for action in actions {
            alertController.addAction(action)
        }

        if showCancel {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            })
            alertController.addAction(cancelAction)
        }

        present(alertController, animated: true, completion: nil)
    }

    func alert(title: String, message: String = "", actionTitle: String = NSLocalizedString("OK", comment: "ok"), cancelHandler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: actionTitle, style: .default, handler: cancelHandler))
        present(alertController, animated: true, completion: nil)
    }

    func errorAlert(message: String) {
        alert(title: "Error", message: message, actionTitle: "Cancel")
    }

    func snackBar(message: String, duration: TTGSnackbarDuration = .middle, actionText: String, block: (() -> Void)? = nil) {
        let snackbar = TTGSnackbar(
            message: message,
            duration: duration,
            actionText: actionText,
            actionBlock: { _ in
                block?()
            }
        )
        snackbar.messageTextFont = .novaBold(14)
        snackbar.actionTextFont = .novaBold(14)
        snackbar.actionTextColor = .red
        snackbar.animationType = .slideFromBottomToTop

        snackbar.show()
    }

    func snackBar(message: String, duration: TTGSnackbarDuration = .middle, actionIcon: UIImage? = nil) {
        let snackbar = TTGSnackbar(
            message: message,
            duration: duration
        )
        snackbar.messageTextFont = .novaBold(14)
        snackbar.actionTextFont = .novaBold(14)
        snackbar.actionTextColor = .red
        snackbar.animationType = .slideFromBottomToTop

        if let actionIcon = actionIcon {
            snackbar.actionIcon = actionIcon
            snackbar.actionBlock = { _ in }
        }

        snackbar.show()
    }

    func showGotoSettingsAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)

        let settingAction = UIAlertAction(title: "Go to settings", style: .default, handler: { _ in
            // open settings
            let url = URL(string: UIApplication.openSettingsURLString)
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!, options: [:])
            }
        })

        alertController.addAction(settingAction)

        // add cancel button

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
}
