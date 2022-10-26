import UIKit

class GMTextField: UITextField {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(
        placeText: String = "",
        type: UIKeyboardType = .default,
        fieldDelegate: UITextFieldDelegate? = nil,
        builder: ((GMTextField) -> Void)? = nil
    ) {
        super.init(frame: .zero)

        autocorrectionType = .no
        autocapitalizationType = .none
        backgroundColor = K.Color.background
        borderStyle = .roundedRect
        tintColor = K.Color.primaryColor
        placeholder = placeText
        translatesAutoresizingMaskIntoConstraints = false
        clearButtonMode = .whileEditing
        font = .nova()
        textColor = .black
        delegate = fieldDelegate
        returnKeyType = .done
        keyboardType = type

        builder?(self)
    }
}
