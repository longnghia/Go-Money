import Lottie
import UIKit

class ToolsViewController: GMMainViewController {
    // MARK: Views

    private lazy var actionCalculator: GMLabelAction = .init(
        text: "Calculator",
        icLeft: UIImage(named: "ic_calculator"),
        action: { [weak self] in
            let calculatorVC = GMMainViewController()
            self?.navigationController?.pushViewController(calculatorVC, animated: true)
        })

    private lazy var actionCurrency: GMLabelAction = .init(
        text: "Currency Exchanger",
        icLeft: UIImage(named: "ic_currency"),
        action: { [weak self] in
            let exchangerVC = GMMainViewController()
            self?.navigationController?.pushViewController(exchangerVC, animated: true)
        })

    private lazy var actionExport: GMLabelAction = .init(
        text: "Export Data",
        icLeft: UIImage(named: "ic_export"),
        action: { [weak self] in
            let exportVC = ExportViewController()
            self?.navigationController?.pushViewController(exportVC, animated: true)
        })

    private lazy var stackActions: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubviews(
            actionCalculator,
            actionCurrency,
            actionExport)
        return stackView
    }()

    private lazy var animationView: LottieAnimationView = .build {
        let animation = LottieAnimation.named(K.Animation.calculator)
        $0.animation = animation
        $0.loopMode = .loop
        $0.play()
    }

    // MARK: - LifeCircle

    override func getTitle() -> String? {
        return "Tools"
    }

    override func setupLayout() {
        super.setupLayout()

        view.addSubviews(stackActions, animationView)

        stackActions.anchor(
            top: animationView.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: Constant.padding,
            paddingLeft: Constant.padding,
            paddingRight: Constant.padding)

        animationView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            paddingTop: Constant.padding,
            width: 150,
            height: 150)
        animationView.centerXToView(view)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !animationView.isAnimationPlaying {
            animationView.play()
        }
    }
}

// MARK: Constant

extension ToolsViewController {
    private enum Constant {
        static let padding: CGFloat = 16
    }
}
