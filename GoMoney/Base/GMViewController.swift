//
//  GMViewController.swift
//  GoMoney
//
//  Created by Golden Owl on 12/10/2022.
//

import UIKit

class GMViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = K.Color.contentBackground
        configureNavigation()
        setupLayout()
    }

    open func setupLayout() {}

    func configureNavigation() {
        let attributes = [NSAttributedString.Key.font:
            K.Font.titleFont]
        UINavigationBar.appearance().titleTextAttributes = attributes as [NSAttributedString.Key: Any]
    }

    func configureBackButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: K.Image.close,
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didTapBack))
        navigationController?.navigationBar.barTintColor = K.Color.primaryColor
    }

    @objc func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}
