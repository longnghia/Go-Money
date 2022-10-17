import FirebaseAuth
import UIKit

class SignInViewModel {
    enum Content {
        static let passwordLengthFailed = "Password should be at least 6 characters long"
        static let fieldEmpty = "Make sure you fill in all fields"
    }

    func signInWithEmailAndPassword(
        email: String,
        password: String,
        onError: @escaping (Error) -> Void)
    {
        AuthService.shared.signIn(with: email, and: password) { [weak self] authResult in
            switch authResult {
            case .success:
                // TODO: fetchUserInfo
                let newUserInfo = Auth.auth().currentUser
                let email = newUserInfo?.email
                let avatar = newUserInfo?.photoURL
                ///
                // NotificationCenter

                NotificationCenter.default.post(name: .loginSuccess, object: nil)

            case let .failure(error):
                onError(error)
            }
        }
    }

    func validateTextField(email: String, password: String) -> String? {
        if email == "" || password == "" {
            return Content.fieldEmpty
        }

        if password.count < 6 {
            return Content.passwordLengthFailed
        }

        return nil
    }
}
