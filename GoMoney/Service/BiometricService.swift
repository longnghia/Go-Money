import BiometricAuthentication

class BiometricService {
    static let shared = BiometricService()

    private init() {}

    func authenticate(completion: @escaping (AuthenticationError?) -> Void) {
        BioMetricAuthenticator.shared.allowableReuseDuration = 30

        BioMetricAuthenticator.authenticateWithBioMetrics(reason: "Please authenticate yourself to unlock GoMoney") { [weak self] result in
            switch result {
            case .success:
                completion(nil)

            case let .failure(error):
                if error == .biometryLockedout {
                    self?.showPasscodeAuthentication(message: error.message(), completion: completion)
                } else {
                    completion(error)
                }
            }
        }
    }

    // show passcode authentication
    func showPasscodeAuthentication(message: String, completion: @escaping (AuthenticationError?) -> Void) {
        BioMetricAuthenticator.authenticateWithPasscode(reason: message) { result in
            switch result {
            case .success:
                completion(nil)
            case let .failure(error):
                completion(error)
            }
        }
    }
}
