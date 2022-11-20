import GradientLoadingBar
import UIKit

class ExportViewController: GMMainViewController {
    // MARK: Properties

    private let viewModel = ExportViewModel()

    private let gradientLoadingBar = GradientLoadingBar(isRelativeToSafeArea: false)

    // MARK: Views

    private lazy var csvActionView: GMLabelActionView = .init(
        text: "Export to CSV",
        icLeft: UIImage(named: "ic_export_csv"),
        action: { [weak self] in
            self?.export(to: .csv)
        }
    )

    private lazy var jsonActionView: GMLabelActionView = .init(
        text: "Export to JSON",
        icLeft: UIImage(named: "ic_export_json"),
        action: { [weak self] in
            self?.export(to: .json)
        }
    )

    private lazy var txtActionView: GMLabelActionView = .init(
        text: "Export to TXT",
        icLeft: UIImage(named: "ic_text"),
        action: { [weak self] in
            self?.export(to: .txt)
        }
    )

    private lazy var realmActionView: GMLabelActionView = .init(
        text: "Export Realm file",
        icLeft: UIImage(named: "ic_export"),
        action: { [weak self] in
            self?.export(to: .realm)
        }
    )

    private lazy var stackActionViews: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubviews(
            csvActionView,
            jsonActionView,
            txtActionView,
            realmActionView
        )
        return stackView
    }()

    override func getTitle() -> String? {
        return "Export Transactions"
    }

    override func setupLayout() {
        super.setupLayout()

        view.addSubviews(stackActionViews)

        stackActionViews.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 32,
            paddingLeft: 16,
            paddingRight: 16
        )
    }

    private func chooseSaveDir(from url: URL) {
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { [weak self] _, completed, _, error in
            if let error = error {
                self?.alert(
                    title: "Error",
                    message: error.localizedDescription,
                    actionTitle: "Cancel"
                )
            } else {
                if completed {
                    self?.snackBar(
                        message: "Export Successfully",
                        actionText: "OK",
                        block: { self?.openFile(url) }
                    )
                } else {
                    self?.snackBar(
                        message: "Aborted",
                        actionText: "Cancel"
                    )
                }
            }
        }
        present(activityViewController, animated: true, completion: nil)
    }

    private func completion(result: Result<URL, Error>) {
        DispatchQueue.main.async {
            switch result {
            case let .failure(err):
                self.alert(
                    title: "Export Fail",
                    message: err.localizedDescription,
                    actionTitle: "Cancel"
                )
            case let .success(url):
                self.chooseSaveDir(from: url)
            }

            self.gradientLoadingBar.fadeOut()
        }
    }

    private func export(to type: ExportType) {
        gradientLoadingBar.fadeIn()

        viewModel.export(type: type) { [weak self] result in
            self?.completion(result: result)
        }
    }

    private func openFile(_: URL) {
        // TODO: Display file.
    }
}
