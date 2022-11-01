//
//  UIViewController+Extension.swift
//  GoMoney
//
//  Created by Golden Owl on 12/10/2022.
//

import TTGSnackbar
import UIKit

extension UIViewController {
    func alert(title: String, message: String = "", actionTitle: String = NSLocalizedString("OK", comment: "ok"), cancelHandler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: actionTitle, style: .default, handler: cancelHandler))
        self.present(alertController, animated: true, completion: nil)
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

    func snackBar(message: String, duration: TTGSnackbarDuration = .middle) {
        let snackbar = TTGSnackbar(
            message: message,
            duration: duration
        )
        snackbar.messageTextFont = .novaBold(14)
        snackbar.actionTextFont = .novaBold(14)
        snackbar.actionTextColor = .red
        snackbar.animationType = .slideFromBottomToTop

        snackbar.show()
    }
}
