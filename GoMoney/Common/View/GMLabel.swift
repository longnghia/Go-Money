//
//  GMLabel.swift
//  GoMoney
//
//  Created by Golden Owl on 13/10/2022.
//

import UIKit

class GMLabel: UILabel {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(
        text: String = "",
        size: CGFloat = 16,
        textColor: UIColor = .black,
        numberOfLines: Int = 0,
        font: String = K.Font.nova,
        builder: ((GMLabel) -> Void)? = nil
    ) {
        self.init(frame: .zero)
        self.text = text
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textAlignment = .center
        self.textColor = textColor
        self.font = UIFont(name: font, size: size)
        builder?(self)
    }
}
