import UIKit

class GMAuthViewController: GMViewController {
    func initData(completion: @escaping (String?) -> Void) {
        GMLoadingView.shared.startLoadingAnimation(with: "Initing data ...")
        TagService.shared.createDefaultDb { err in
            GMLoadingView.shared.endLoadingAnimation()
            if let err = err {
                completion(err.localizedDescription)
            } else {
                completion(nil)
            }
        }
    }

    func initDataAndGoHome() {
        initData { [weak self] err in
            if let err = err {
                self?.errorAlert(message: err)
            } else {
                self?.navigateToMainVC()
            }
        }
    }

    func navigateToMainVC() {
        let homeVC = GMTabBarViewController()
        if let delegate = view.window?.windowScene?.delegate as? SceneDelegate {
            if let window = delegate.window {
                window.rootViewController = homeVC

                let options: UIView.AnimationOptions = .transitionCrossDissolve
                let duration: TimeInterval = 0.5
                UIView.transition(
                    with: window,
                    duration: duration,
                    options: options,
                    animations: {},
                    completion: { _ in }
                )
            }
        }
    }

    func restoreData(completion: @escaping (Error?) -> Void) {
        GMLoadingView.shared.startLoadingAnimation(with: "Restoring data ...")
        AuthService.shared.restoreUserData(completion: { err in
            GMLoadingView.shared.endLoadingAnimation()
            completion(err)
        })
    }

    func restoreDataAndGoHome() {
        restoreData { [weak self] err in
            if let err = err {
                self?.errorAlert(message: err.localizedDescription)
            } else {
                self?.navigateToMainVC()
            }
        }
    }

    func checkIfNewUser(completion: @escaping (Bool) -> Void) {
        RemoteService.shared.checkIfUserExist { result in
            switch result {
            case let .success(exist):
                completion(!exist)
            case let .failure(err):
                self.errorAlert(message: err.localizedDescription)
            }
        }
    }
}
