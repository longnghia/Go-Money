import FirebaseAuth
import UIKit

typealias AuthServiceResult = (Result<AuthDataResult, Error>) -> Void

class AuthService {
    static let shared = AuthService()

    private init() {}

    func signIn(with email: String, and password: String, completion: @escaping AuthServiceResult) {
        GMLoadingView.shared.startLoadingAnimation()

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in

            GMLoadingView.shared.endLoadingAnimation()

            if let error = error {
                completion(.failure(error))
            }
            else
            if let authResult = authResult {
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
            completion(.success(true))
        }
        catch let signOutError as NSError {
            completion(.failure(signOutError))
            print("Error signing out: %@", signOutError)
        }
    }
}
