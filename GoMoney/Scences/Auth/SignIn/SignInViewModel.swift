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
        completion: @escaping (Error?) -> Void
    ) {
        AuthService.shared.signIn(with: email, and: password) { [weak self] authResult in
            switch authResult {
            case .success:
                // TODO: fetchUserInfo
                let newUserInfo = Auth.auth().currentUser
                let email = newUserInfo?.email
                let avatar = newUserInfo?.photoURL

                completion(nil)
            case let .failure(error):
                completion(error)
            }
        }
    }

    func validateTextField(email: String, password: String, completion: (String?) -> Void) {
        if email == "" || password == "" {
            return completion(Content.fieldEmpty)
        }

        if password.count < 6 {
            return completion(Content.passwordLengthFailed)
        }

        completion(nil)
    }
}
