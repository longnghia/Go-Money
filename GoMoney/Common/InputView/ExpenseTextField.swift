/// https://github.com/sag333ar/InputViews
/// https://github.com/edgar-zigis/CocoaTextField

import UIKit

public class ExpenseTextField: UITextField {
    //  MARK: - Open variables -

    open var focusedborderColor = UIColor.action

    open var borderColor = UIColor.lightGray {
        didSet { layer.borderColor = borderColor.cgColor }
    }

    open var borderWidth: CGFloat = 1.0 {
        didSet { layer.borderWidth = borderWidth }
    }

    open var focusedBorderWidth: CGFloat = 1.2 {
        didSet {
            layer.borderWidth = focusedBorderWidth
        }
    }

    open var cornerRadius: CGFloat = 8 {
        didSet { layer.cornerRadius = cornerRadius }
    }

    private let padding: CGFloat = 16

    //  MARK: Private

    private func initializeTextField() {
        configureTextField()
        addObservers()
    }

    private func configureTextField() {
        autocorrectionType = .no
        spellCheckingType = .no
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor.cgColor
    }

    private func addObservers() {
        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    private func activateTextField() {
        UIView.animate(withDuration: 0.2) {
            self.layer.borderColor = self.focusedborderColor.cgColor
            self.layer.borderWidth = self.focusedBorderWidth
        }
    }

    private func deactivateTextField() {
        UIView.animate(withDuration: 0.3) {
            self.layer.borderColor = self.borderColor.cgColor
            self.layer.borderWidth = self.borderWidth
        }
    }

    @objc private func textFieldDidChange() {
        UIView.animate(withDuration: 0.2) {
            self.layer.borderColor = self.focusedborderColor.cgColor
        }
    }

    //  MARK: UIKit methods

    @discardableResult
    override open func becomeFirstResponder() -> Bool {
        activateTextField()
        return super.becomeFirstResponder()
    }

    @discardableResult
    override open func resignFirstResponder() -> Bool {
        deactivateTextField()
        return super.resignFirstResponder()
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.textRect(forBounds: bounds)
        let rect = CGRect(
            x: padding,
            y: superRect.origin.y,
            width: superRect.size.width - padding * 1.5,
            height: superRect.size.height
        )
        return rect
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.editingRect(forBounds: bounds)
        let rect = CGRect(
            x: padding,
            y: superRect.origin.y,
            width: superRect.size.width - padding * 1.5,
            height: superRect.size.height
        )
        return rect
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

    //  MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeTextField()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeTextField()
    }
}
