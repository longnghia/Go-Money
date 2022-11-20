import FirebaseAuth

struct GMUser: Codable {
    let uid: String
    var email: String?
    var name: String?
    var photoUrl: String?
}

class UserManager {
    static let shared = UserManager()

    private init() {}

    // FirebaseUser
    func saveUserInfo(user: User) {
        UserDefaults.standard.set(user.uid, forKey: "userId")
        UserDefaults.standard.set(user.email, forKey: "userEmail")
        UserDefaults.standard.set(user.photoURL?.absoluteString, forKey: "userPhotoUrl")
        UserDefaults.standard.set(user.displayName, forKey: "userName")
    }

    func clearUserInfo() {
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userPhotoUrl")
        UserDefaults.standard.removeObject(forKey: "userName")
    }

    // GMUser
    func getUserInfo() -> GMUser? {
        let id = UserDefaults.standard.string(forKey: "userId")
        let email = UserDefaults.standard.string(forKey: "userEmail")
        let photo = UserDefaults.standard.string(forKey: "userPhotoUrl")
        let name = UserDefaults.standard.string(forKey: "userName")
        guard let id = id else {
            return nil
        }
        return GMUser(uid: id, email: email, name: name, photoUrl: photo)
    }

    func getUserId() -> String? {
        return UserDefaults.standard.string(forKey: "userId")
    }
}
