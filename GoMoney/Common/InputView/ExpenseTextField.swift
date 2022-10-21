/// https://github.com/sag333ar/InputViews

import UIKit

public class ExpenseTextField: UITextField {
    override public func layoutSubviews() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: frame.height - 1, width: frame.width, height: 0.75)
        bottomLine.backgroundColor = K.Color.borderOnContentBg.cgColor
        borderStyle = UITextField.BorderStyle.none
        layer.addSublayer(bottomLine)
    }

    override public func target(forAction action: Selector, withSender sender: Any?) -> Any? {
        if action == #selector(UIResponderStandardEditActions.paste(_:))
            ||
            action == #selector(UIResponderStandardEditActions.cut(_:))
        {
            return nil
        }
        return super.target(forAction: action, withSender: sender)
    }
}
