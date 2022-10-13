//
//  GMLabel.swift
//  GoMoney
//
//  Created by Golden Owl on 13/10/2022.
//

import UIKit

class GMLabel: UILabel {
    
    var gmFont = K.Font.nova {
        didSet {
            self.font = UIFont(name: self.gmFont, size: self.gmSize)
        }
    }
    
    var gmSize: CGFloat = 16 {
        didSet {
            self.font = UIFont(name: gmFont, size: gmSize)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    private func setup() {
        self.font = UIFont(name: self.gmFont, size: self.gmSize)
    }
}
