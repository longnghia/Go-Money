import UIKit

class GMLoadingView {
    static let shared = GMLoadingView()

    private init() {}

    private lazy var blurView = UIVisualEffectView()

    private lazy var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.startAnimating()
        indicatorView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        indicatorView.color = .primary
        return indicatorView
    }()

    var loadingLabel = GMLabel(style: .regular) {
        $0.textColor = .primary
    }

    func endLoadingAnimation() {
        indicatorView.removeFromSuperview()
        blurView.removeFromSuperview()
    }

    func startLoadingAnimation(with label: String? = "Loading ...") {
        let window = UIApplication.shared.windows[0]

        window.addSubview(blurView)

        blurView.frame = window.frame
        blurView.effect = UIBlurEffect(style: .extraLight)

        loadingLabel.text = label

        blurView.contentView.addSubviews(indicatorView, loadingLabel)

        indicatorView.centerInSuperview()

        loadingLabel.centerX(inView: blurView)
        loadingLabel.anchor(
            top: indicatorView.bottomAnchor,
            paddingTop: 16
        )
    }
}
