import FirebaseAuth
import UIKit

class SignInPasswordVC: GMViewController {
    // MARK: - Content

    private enum Content {
        static let title = "Sign in with Email"
        static let email = "Enter Your Email"
        static let password = "Enter Your Password"
        static let login = "Login"
        static let passwordLengthFailed = "Password should be at least 6 characters long"
        static let fieldEmpty = "Make sure you fill in all fields"
    }
    
    private enum Constant {
        static let padding: CGFloat = 16
    }
    
    // MARK: - private properties

    private lazy var fieldEmail: TextFieldSignUp = .init(
        title: Content.email,
        type: .emailAddress,
        delegate: self)
    {
        $0.inputField.addTarget(self,
                                action: #selector(self.textFieldDidChanged),
                                for: .editingChanged)
    }
    
    private lazy var fieldPassword: TextFieldSignUp = .init(
        title: Content.password,
        secure: true,
        delegate: self)
    {
        $0.inputField.addTarget(self,
                                action: #selector(self.textFieldDidChanged),
                                for: .editingChanged)
    }
    
    private lazy var errorLabel: GMLabel = .init(style: .smallBold) {
        $0.textColor = K.Color.error
        $0.numberOfLines = 0
    }
    
    private lazy var inputFields: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constant.padding
        stackView.addArrangedSubviews(fieldEmail, fieldPassword)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var logginButton: GMButton = .init(text: Content.login, color: .white) {
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .primary
        $0.addTarget(self, action: #selector(self.didTapLogin), for: .touchUpInside)
    }
    
    // MARK: - Setup Layout
    
    override func setupLayout() {
        super.setupLayout()
        
        view.backgroundColor = .white
        view.addSubviews(inputFields, errorLabel, logginButton)
        
        inputFields.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 50,
            paddingLeft: Constant.padding,
            paddingRight: Constant.padding)
        
        errorLabel.anchor(
            top: inputFields.bottomAnchor,
            left: inputFields.leftAnchor,
            right: inputFields.rightAnchor,
            paddingTop: 24)
        
        logginButton.anchor(
            left: view.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.rightAnchor,
            paddingLeft: Constant.padding,
            paddingBottom: Constant.padding,
            paddingRight: Constant.padding,
            height: 40)
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        title = Content.title
    }
    
    // MARK: - Method
    
    @objc func textFieldDidChanged() {
        errorLabel.text = ""
    }

    @objc func didTapLogin() {
        if let error = validateTF() {
            errorLabel.text = error
        } else {
            errorLabel.text = ""
            let email: String = fieldEmail.inputField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            let password: String = fieldPassword.inputField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            signInWithEmailAndPassword(email: email, password: password)
        }
    }
    
    private func signInWithEmailAndPassword(email: String, password: String) {
        AuthService.shared.signIn(with: email, and: password) { [weak self] authResult in
            switch authResult {
            case .success:
                // TODO: fetchUserInfo
                let newUserInfo = Auth.auth().currentUser
                let email = newUserInfo?.email
                let avatar = newUserInfo?.photoURL
                ///
                self?.navigateToMainVC()
            case let .failure(error):
                self?.errorLabel.text = error.localizedDescription
                print("\(error.localizedDescription)")
            }
        }
    }
    
    private func navigateToMainVC() {
        let mainVC = UIViewController()
        let navVC = UINavigationController(rootViewController: mainVC)
        if let delegate = view.window?.windowScene?.delegate as? SceneDelegate {
            delegate.window?.rootViewController = navVC
        }
    }
    
    private func validateTF() -> String? {
        let email: String = fieldEmail.inputField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password: String = fieldPassword.inputField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if email == "" || password == "" {
            return Content.fieldEmpty
        }
        
        if password.count < 6 {
            return Content.passwordLengthFailed
        }
        
        return nil
    }
}

extension SignInPasswordVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fieldEmail.inputField {
            fieldPassword.inputField.becomeFirstResponder()
        } else if textField == fieldPassword.inputField {
            fieldPassword.inputField.resignFirstResponder()
            didTapLogin()
        }
        return true
    }
}
