import UIKit

class GMViewController: UIViewController {
    open func addObservers() {}
    open func removeObservers() {}

    open func getTitle() -> String? {
        return nil
    }

    open func getBackground() -> UIColor? {
        return K.Color.background
    }

    func setTitle(_ title: String? = nil) {
        self.title = title
    }

    open func setBackground(_ color: UIColor? = K.Color.background) {
        if let color = color {
            view.backgroundColor = color
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle(getTitle())
        setBackground(getBackground())
        configureNavigation()
        setupLayout()
        addObservers()
    }

    deinit {
        removeObservers()
    }

    open func setupLayout() {}

    func configureNavigation() {
        let attributes = [NSAttributedString.Key.font:
            K.Theme.titleFont]
        UINavigationBar.appearance().titleTextAttributes = attributes as [NSAttributedString.Key: Any]
    }

    func configureBackButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: K.Image.close,
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didTapBack))
        navigationController?.navigationBar.barTintColor = K.Color.primaryColor
    }

    @objc func didTapBack() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Keyboard

    var onKeyboardWillShow: ((CGFloat, Double) -> Void)?
    var onKeyboardWillHide: ((CGFloat, Double) -> Void)?

    func setupKeyboard(
        onKeyboardWillShow: ((CGFloat, Double) -> Void)?,
        onKeyboardWillHide: ((CGFloat, Double) -> Void)?,
        hideKeyboarOnTap: Bool = true
    ) {
        self.onKeyboardWillShow = onKeyboardWillShow
        self.onKeyboardWillHide = onKeyboardWillHide

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )

        if hideKeyboarOnTap {
            hideKeyboardOnTap()
        }
    }

    @objc func handleKeyboardWillShow(notification: NSNotification) {
        let kFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let kDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        guard let height = kFrame?.height, let duration = kDuration else { return }

        onKeyboardWillShow?(height, duration)
    }

    @objc func handleKeyboardWillHide(notification: NSNotification) {
        let kFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let kDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        guard let height = kFrame?.height, let duration = kDuration else { return }

        onKeyboardWillHide?(height, duration)
    }

    func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc
    func hideKeyboard() {
        view.endEditing(true)
    }

    func openURL(_ url: String) {
        guard let url = URL(string: url) else {
            errorAlert(message: "Can't open \(url)")
            return
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
