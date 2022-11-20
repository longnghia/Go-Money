import UIKit

class SignUpPasswordVC: GMAuthViewController {
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

    private let viewModel = SignUpViewModel()

    private lazy var fieldEmail: TextFieldSignUp = .init(
        title: Content.email,
        type: .emailAddress,
        delegate: self
    )
    private lazy var fieldPassword: TextFieldSignUp = .init(
        title: Content.password,
        secure: true,
        delegate: self
    )

    private lazy var fieldRePassword: TextFieldSignUp = .init(
        title: Content.repassword,
        secure: true,
        delegate: self
    )

    private lazy var errorLabel: GMLabel = .init(style: .smallBold, isCenter: true) {
        $0.textColor = K.Color.error
        $0.numberOfLines = 0
    }

    private lazy var inputFields: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constant.padding
        stackView.addArrangedSubviews(fieldEmail, fieldPassword, fieldRePassword)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    private lazy var nextButton: GMButton = .init(
        text: Content.next,
        color: .white,
        builder: {
            $0.layer.cornerRadius = 8
            $0.backgroundColor = .primary
            $0.addTarget(self, action: #selector(self.didTapNext), for: .touchUpInside)
        }
    )

    override func configureNavigation() {
        super.configureNavigation()
        configureBackButton()
        title = Content.title
    }

    override func setupLayout() {
        super.setupLayout()

        view.backgroundColor = K.Color.background

        view.addSubviews(inputFields, errorLabel, nextButton)

        inputFields.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 50,
            paddingLeft: 16,
            paddingRight: 16
        )

        nextButton.anchor(
            left: view.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.rightAnchor,
            paddingLeft: Constant.padding,
            paddingBottom: Constant.padding,
            paddingRight: Constant.padding,
            height: 40
        )

        errorLabel.anchor(
            top: inputFields.bottomAnchor,
            left: inputFields.leftAnchor,
            right: inputFields.rightAnchor,
            paddingTop: 24
        )

        [fieldEmail, fieldPassword, fieldRePassword].forEach {
            $0.inputField.addTarget(
                self,
                action: #selector(self.textFieldDidChanged),
                for: .editingChanged
            )
        }
    }

    @objc func didTapNext() {
        let email: String =
            fieldEmail.inputField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password: String =
            fieldPassword.inputField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        let repassword: String =
            fieldRePassword.inputField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        viewModel.validateTextField(email: email, password: password, repassword: repassword) { error in
            if error != nil {
                errorLabel.text = error
            } else {
                errorLabel.text = ""

                GMLoadingView.shared.startLoadingAnimation(with: "Signing up ...")
                viewModel.signUpWithEmailAndPassword(email: email, password: password) { [weak self] error in
                    GMLoadingView.shared.endLoadingAnimation()
                    if error != nil {
                        self?.errorLabel.text = error?.localizedDescription
                    } else {
                        // TODO: navigateToDetailVC
                        self?.initDataAndGoHome()
                    }
                }
            }
        }
    }

    @objc
    private func textFieldDidChanged() {
        errorLabel.text = ""
    }

    private func navigateToDetailVC() {
        let vc = SignUpDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SignUpPasswordVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fieldEmail.inputField {
            fieldPassword.inputField.becomeFirstResponder()
        } else if textField == fieldPassword.inputField {
            fieldRePassword.inputField.becomeFirstResponder()
        } else if textField == fieldRePassword.inputField {
            fieldRePassword.inputField.resignFirstResponder()
            didTapNext()
        }
        return true
    }
}
