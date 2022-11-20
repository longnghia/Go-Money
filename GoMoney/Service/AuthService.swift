import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import UIKit

typealias AuthServiceResult = (Result<AuthDataResult, Error>) -> Void

class AuthService {
    static let shared = AuthService()

    private init() {}

    func signUp(with email: String, and password: String, completion: @escaping AuthServiceResult) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in

            if let error = error {
                completion(.failure(error))
            } else if let authResult = authResult {
                self.saveUserInfo()
                completion(.success(authResult))
            } else {
                print("Unknown Error")
            }
        }
    }

    func signIn(with email: String, and password: String, completion: @escaping AuthServiceResult) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in

            GMLoadingView.shared.endLoadingAnimation()

            if let error = error {
                completion(.failure(error))
            } else
            if let authResult = authResult {
                self.saveUserInfo()
                completion(.success(authResult))
            } else {
                print("Unknown Error")
            }
        }
    }

    func signInGoogle(with viewController: UIViewController, completion: @escaping (String?) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion("FirebaseApp clientID nil.")
            return
        }

        let config = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.signIn(with: config, presenting: viewController) { user, error in

            if let error = error {
                completion(error.localizedDescription)
                return
            }

            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                completion("Google token error.")
                return
            }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: authentication.accessToken
            )

            Auth.auth().signIn(with: credential) { [weak self] _, error in
                if let error = error {
                    completion(error.localizedDescription)
                    return
                }

                self?.saveUserInfo()
                completion(nil)
            }
        }
    }

    func signOut(completion: @escaping (Result<Bool, Error>) -> Void) {
        do {
            try Auth.auth().signOut()

            clearData()
            completion(.success(true))
        } catch let signOutError as NSError {
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

        let settingDomain = "com.kappa.expense.settings"
        if let pref = UserDefaults(suiteName: settingDomain) {
            pref.removePersistentDomain(forName: settingDomain)
        }

        // remove realm
        DataService.shared.dropAllTable()
    }

    func restoreUserData(completion: @escaping (Error?) -> Void) {
        RemoteService.shared.getAllTags { result in
            switch result {
            case let .failure(err):
                completion(err)
            case let .success(tags):
                TagService.shared.setTags(tags: tags) { err in
                    if let err = err {
                        completion(err)
                    } else {
                        print("[restore] \(tags.count) tags")
                        RemoteService.shared.getAllTransactions { result in
                            switch result {
                            case let .success(transactions):
                                print("[restore] \(transactions.count) transactions")
                                DataService.shared.addTransactions(transactions) { err in
                                    completion(err)
                                }
                            case let .failure(err):
                                completion(err)
                            }
                        }
                    }
                }
            }
        }
    }
}
