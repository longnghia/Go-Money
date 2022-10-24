import UIKit

class AddExpenseField: UIView {
    lazy var label = GMLabel {
        $0.textColor = .darkGray
        $0.textAlignment = .left
    }

    lazy var inputField: ExpenseTextField = .build {
        $0.tintColor = .clear
    }
    
    var name: String = ""
    var defaultValue: String = ""
    
    init(name: String, defaultValue: String = "", makeInputView: ((ExpenseTextField) -> Void)? = nil) {
        super.init(frame: .zero)
        
        self.name = name
        self.defaultValue = defaultValue
        setView()
        makeInputView?(inputField)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(label, inputField)
        label.text = name
        inputField.text = defaultValue
        
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        label.anchor(
            top: topAnchor,
            left: leftAnchor)
        label.centerYToView(self)
        label.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2).isActive = true
        
        inputField.anchor(
            top: label.topAnchor,
            left: label.rightAnchor,
            right: rightAnchor,
            paddingLeft: 8)
        inputField.centerYToView(self)
    }
}