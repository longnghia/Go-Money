//
//  GMButton.swift
//  GoMoney
//
//  Created by Golden Owl on 13/10/2022.
//

import UIKit

class GMButton: UIButton {

    var gmFont = K.Font.nova {
        didSet {
            self.titleLabel?.font  = UIFont(name: self.gmFont, size: self.gmSize)
        }
    }
    
    var gmSize: CGFloat = 16 {
        didSet {
            self.titleLabel?.font  = UIFont(name: gmFont, size: gmSize)
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
        self.titleLabel?.font = UIFont(name: gmFont, size: gmSize)
        self.setTitleColor(.black, for: .normal)
    }
}
