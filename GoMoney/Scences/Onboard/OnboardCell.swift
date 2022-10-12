//
//  OnboardCell.swift
//  GoMoney
//
//  Created by Golden Owl on 12/10/2022.
//

import UIKit

class OnboardCell: UICollectionViewCell {
    static let identifier = "onboard_cell"
    
    var onboardVC: OnboardViewController!
    
    // MARK: - private properties

    private lazy var topicImage: UIImageView = .build { topicImage in
        topicImage.contentMode = .scaleAspectFill
        topicImage.layer.cornerRadius = 75
        topicImage.layer.masksToBounds = true
    }
     
    private lazy var topicLabel: UILabel = .build { topicLabel in
        topicLabel.font = UIFont(name: K.Font.nova, size: 28)
        topicLabel.textAlignment = .center
    }
     
    private lazy var descriptionLabel: UILabel = .build { descriptionLabel in
        descriptionLabel.textColor = .gray
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont(name: K.Font.nova, size: 18)
    }
    
    var page: OnboardPage? {
        didSet {
            topicImage.image = UIImage(named: page?.imageName ?? "")
            topicLabel.text = page?.topicText
            descriptionLabel.text = page?.descriptionText
        }
    }
         
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
    }
     
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup layout

    private func setupLayout() {
        addSubviews(topicImage, topicLabel, descriptionLabel)
        
        topicImage.centerXToSuperview()
        topicImage.centerYToSuperview(offset: -center.y / 2)
        topicImage.anchor(width: 200, height: 200)
        
        topicLabel.anchor(top: topicImage.bottomAnchor, paddingTop: 16)
        topicLabel.centerXToSuperview()

        descriptionLabel.centerXToSuperview()
        descriptionLabel.anchor(top: topicLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 24, paddingLeft: 8, paddingRight: 8)
    }
    
    // MARK: public methods

    public func onWillAppear(_ view: UIView) {
        topicImage.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        descriptionLabel.transform = CGAffineTransform(translationX: view.frame.origin.x + view.frame.width / 2, y: 0)
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.topicImage.transform = .identity
            self.descriptionLabel.transform = .identity
        })
    }
}
