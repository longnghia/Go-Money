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
        view.backgroundColor = K.Color.background
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

    func configureRootTitle(leftImage: UIImage? = nil, leftTitle: String? = nil, rightImage: UIImage? = nil) {
        if let leftBarImage =
            leftImage?.white(),
            let leftTitle = leftTitle
        {
            let leftBarIcon = UIBarButtonItem(
                image: leftBarImage,
                style: .done,
                target: self,
                action: nil)

            let leftBarTitle = UIBarButtonItem(
                title: leftTitle,
                style: .plain,
                target: self,
                action: nil)

            leftBarTitle.setTitleTextAttributes(
                [.foregroundColor: UIColor.white, .font: K.Theme.titleFont],
                for: .disabled)

            leftBarIcon.isEnabled = false
            leftBarTitle.isEnabled = false

            navigationItem.leftBarButtonItems = [leftBarIcon, leftBarTitle]
        }
        if let rightBarImage = rightImage?.white() {
            let rightBarIcon = UIBarButtonItem(
                image: rightBarImage,
                style: .done,
                target: self,
                action: nil)
            navigationItem.rightBarButtonItem = rightBarIcon
        }

        navigationController?.navigationBar.barTintColor = .white
    }

    func notifyDataDidChange() {
        NotificationCenter.default.post(name: .dataChanged, object: self)
    }
}
