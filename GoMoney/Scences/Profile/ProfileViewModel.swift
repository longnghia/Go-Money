
class ProfileViewModel {
    func logOut(completion: @escaping (Error?) -> Void) {
        AuthService.shared.signOut { result in
            switch result {
            case .success:
                completion(nil)
            case let .failure(error):
                completion(error)
            }
        }
    }

    func getUserInfo(completion: @escaping (GMUser?) -> Void) {
        let user = UserManager.shared.getUserInfo()
        completion(user)
    }
}
