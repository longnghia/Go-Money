//
//  GMViewController.swift
//  GoMoney
//
//  Created by Golden Owl on 12/10/2022.
//

import UIKit

class GMViewController: UIViewController {
    open func addObservers() {}
    open func removeObservers() {}

    open func getTitle() -> String? {
        return nil
    }

    open func getBackground() -> UIColor? {
        return K.Color.background
    }

    func setTitle(_ title: String? = nil) {
        if let title = title {
            self.title = title
        }
    }

    open func setBackground(_ color: UIColor? = K.Color.background) {
        if let color = color {
            view.backgroundColor = color
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle(getTitle())
        setBackground(getBackground())
        configureNavigation()
        setupLayout()
        addObservers()
    }

    deinit {
        removeObservers()
    }

    open func setupLayout() {}

    func configureNavigation() {
        let attributes = [NSAttributedString.Key.font:
            K.Theme.titleFont]
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
