//
//  UIViewController+Extension.swift
//  GoMoney
//
//  Created by Golden Owl on 12/10/2022.
//

import UIKit

extension UIViewController {
    func alert(_ message: String, actionTitle: String = NSLocalizedString("OK", comment: "ok"), cancelHandler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: actionTitle, style: .default, handler: cancelHandler))
        self.present(alertController, animated: true, completion: nil)
    }
}
