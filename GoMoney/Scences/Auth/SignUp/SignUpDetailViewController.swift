import UIKit

class SignUpDetailViewController: GMViewController {
    private enum Constant {
        static let padding: CGFloat = 16
    }
    
    private enum Content {
        static let title = "Enter your info"
        static let name = "What's your name?"
        static let dob = "What's your date of birth?"
        static let income = "What's your monthly salary?"
        static let next = "Next"
    }

    private lazy var fieldName: TextFieldSignUp = .init(title: Content.name, delegate: self)
    
    private lazy var fieldDob: TextFieldSignUp = .init(
        title: Content.dob,
        type: .numberPad,
        delegate: self)
    
    private lazy var fieldIncome: TextFieldSignUp = .init(
        title: Content.income,
        type: .numberPad,
        delegate: self)

    private lazy var inputFields: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constant.padding
        stackView.addArrangedSubviews(fieldName, fieldDob, fieldIncome)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var nextButton: GMButton = .init(text: Content.next, color: .white) {
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .primary
        $0.addTarget(self, action: #selector(self.didTapNext), for: .touchUpInside)
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        configureBackButton()
        title = Content.title
    }

    override func setupLayout() {
        super.setupLayout()
        
        view.backgroundColor = K.Color.background
  
        view.addSubviews(inputFields, nextButton)
        
        inputFields.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 50,
            paddingLeft: 16,
            paddingRight: 16)
        
        nextButton.anchor(
            left: view.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.rightAnchor,
            paddingLeft: Constant.padding,
            paddingBottom: Constant.padding,
            paddingRight: Constant.padding,
            height: 40)
    }
    
    @objc func didTapNext() {
        print("save info to firebase")
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
