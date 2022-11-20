import Lottie
import UIKit

class ToolsViewController: GMMainViewController {
    // MARK: Views

    private lazy var calculatorActionViews: GMLabelActionView = .init(
        text: "Calculator",
        icLeft: UIImage(named: "ic_calculator"),
        action: { [weak self] in

            let storyBoard: UIStoryboard = .init(name: "Calculator", bundle: nil)
            let calculatorVC = storyBoard.instantiateViewController(withIdentifier: "calculatorStoryboardID")
            self?.present(calculatorVC, animated: true)
        }
    )

    private lazy var currencyActionViews: GMLabelActionView = .init(
        text: "Currency Exchanger",
        icLeft: UIImage(named: "ic_currency"),
        action: { [weak self] in
            let exchangerVC = ExchangeViewController()
            self?.present(exchangerVC, animated: true)
        }
    )

    private lazy var exportActionViews: GMLabelActionView = .init(
        text: "Export Data",
        icLeft: UIImage(named: "ic_export"),
        action: { [weak self] in
            let exportVC = ExportViewController()
            self?.navigationController?.pushViewController(exportVC, animated: true)
        }
    )

    private lazy var stackActionViews: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubviews(
            calculatorActionViews,
            currencyActionViews,
            exportActionViews
        )
        return stackView
    }()

    private lazy var animationView: LottieAnimationView = .build {
        let animation = LottieAnimation.named(K.Animation.calculator)
        $0.animation = animation
        $0.backgroundBehavior = .pauseAndRestore
        $0.loopMode = .loop
        $0.play()
    }

    // MARK: - LifeCircle

    override func getTitle() -> String? {
        return "Tools"
    }

    override func setupLayout() {
        super.setupLayout()

        view.addSubviews(stackActionViews, animationView)

        stackActionViews.anchor(
            top: animationView.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: Constant.padding,
            paddingLeft: Constant.padding,
            paddingRight: Constant.padding
        )

        animationView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            paddingTop: Constant.padding,
            width: 150,
            height: 150
        )
        animationView.centerXToView(view)
    }
}

// MARK: Constant

extension ToolsViewController {
    private enum Constant {
        static let padding: CGFloat = 16
    }
}
