import FirebaseAuth
import UIKit

class SignUpViewModel {
    func signUpWithEmailAndPassword(
        email: String,
        password: String,
        completion: @escaping (Error?) -> Void
    ) {
        AuthService.shared.signUp(with: email, and: password) { authResult in
            switch authResult {
            case .success:
                // TODO: fetchUserInfo

                completion(nil)
            case let .failure(error):
                completion(error)
            }
        }
    }

    func validateTextField(email: String, password: String, repassword: String, completion: (String?) -> Void) {
        if email == "" || password == "" {
            return completion(.fieldEmpty)
        }

        if password.count < 6 {
            return completion(.passwordLengthFailed)
        }

        if repassword != password {
            return completion(.passwordNotMatch)
        }

        completion(nil)
    }
}

private extension String {
    static let passwordLengthFailed = "Password should be at least 6 characters long"
    static let fieldEmpty = "Make sure you fill in all fields"
    static let passwordNotMatch = "Password not match"
}
