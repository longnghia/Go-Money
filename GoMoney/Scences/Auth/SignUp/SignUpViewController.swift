import UIKit

class SignUpViewController: GMViewController {
    private enum Constant {
        static let padding: CGFloat = 16
    }
    
    private enum Content {
        static let title = "Create a new account"
        static let email = "What's your mail?"
        static let password = "Enter your password"
        static let repassword = "Re-enter your password"
        static let next = "Next"
    }

    // MARK: - private properties

    private lazy var fieldEmail: TextFieldSignUp = .init(
        title: Content.email,
        type: .emailAddress,
        delegate: self)
    private lazy var fieldPassword: TextFieldSignUp = .init(
        title: Content.password,
        secure: true,
        delegate: self)

    private lazy var fieldRePassword: TextFieldSignUp = .init(
        title: Content.repassword,
        secure: true,
        delegate: self)

    private lazy var inputFields: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constant.padding
        stackView.addArrangedSubviews(fieldEmail, fieldPassword, fieldRePassword)
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
        let vc = SignUpDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SignUpDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
