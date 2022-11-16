import FirebaseAuth
import UIKit

typealias AuthServiceResult = (Result<AuthDataResult, Error>) -> Void

class AuthService {
    static let shared = AuthService()

    private init() {}

    func signUp(with email: String, and password: String, completion: @escaping AuthServiceResult) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in

            if let error = error {
                completion(.failure(error))
            }
            else if let authResult = authResult {
                self.saveUserInfo()
                completion(.success(authResult))
            }
            else {
                print("Unknown Error")
            }
        }
    }

    func signIn(with email: String, and password: String, completion: @escaping AuthServiceResult) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in

            GMLoadingView.shared.endLoadingAnimation()

            if let error = error {
                completion(.failure(error))
            }
            else
            if let authResult = authResult {
                self.saveUserInfo()
                completion(.success(authResult))
            }
            else {
                print("Unknown Error")
            }
        }
    }

    func signOut(completion: @escaping (Result<Bool, Error>) -> Void) {
        do {
            try Auth.auth().signOut()

            clearData()
            completion(.success(true))
        }
        catch let signOutError as NSError {
            completion(.failure(signOutError))
        }
    }

    private func saveUserInfo() {
        guard let user = Auth.auth().currentUser else {
            return
        }

        UserManager.shared.saveUserInfo(user: user)
    }

    private func clearData() {
        // remove UserDefaults

        UserManager.shared.clearUserInfo()

        // remove setting

        if let appDomain = Bundle.main.bundleIdentifier {
            if let pref = UserDefaults(suiteName: "com.kappa.expense.settings") {
                pref.removePersistentDomain(forName: appDomain)
            }
        }

        // TODO: remove realm
    }
}
