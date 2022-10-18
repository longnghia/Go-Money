//
//  GMViewController.swift
//  GoMoney
//
//  Created by Golden Owl on 12/10/2022.
//

import UIKit

/// BaseMainViewController with colored navigationBar and colored Background
class GMMainViewController: GMViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = K.Color.contentBackground
    }

    override func configureNavigation() {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: K.Theme.titleFont]

        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = K.Color.actionBackground
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
}
