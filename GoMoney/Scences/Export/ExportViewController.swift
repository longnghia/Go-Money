import GradientLoadingBar
import UIKit

class ExportViewController: GMMainViewController {
    // MARK: Properties

    private let viewModel = ExportViewModel()
    
    private let gradientLoadingBar = GradientLoadingBar(isRelativeToSafeArea: false)
    
    // MARK: Views
    
    private lazy var actionCSV: GMLabelAction = .init(
        text: "Export to CSV",
        icLeft: UIImage(named: "ic_export_csv"),
        action: { [weak self] in
            self?.export(to: .csv)
        })
    
    private lazy var actionJSON: GMLabelAction = .init(
        text: "Export to JSON",
        icLeft: UIImage(named: "ic_export_json"),
        action: { [weak self] in
            self?.export(to: .json)
        })
    
    private lazy var actionTxt: GMLabelAction = .init(
        text: "Export to TXT",
        icLeft: UIImage(named: "ic_text"),
        action: { [weak self] in
            self?.export(to: .txt)
        })
    
    private lazy var actionRealm: GMLabelAction = .init(
        text: "Export Realm file",
        icLeft: UIImage(named: "ic_export"),
        action: { [weak self] in
            self?.export(to: .realm)
        })
    
    private lazy var stackActions: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubviews(
            actionCSV,
            actionJSON,
            actionTxt,
            actionRealm)
        return stackView
    }()
    
    override func getTitle() -> String? {
        return "Export Transactions"
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        view.addSubviews(stackActions)
        
        stackActions.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 24,
            paddingLeft: 16,
            paddingRight: 16)
    }
    
    private func completion(err: Error?) {
        if let err = err {
            alert(
                title: "Export Fail",
                message: err.localizedDescription,
                actionTitle: "Cancel")
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.snackBar(
                    message: "Export Successfully",
                    actionText: "Open",
                    block: {
                        self?.openFile()
                    })
            }
        }
        DispatchQueue.main.async {
            self.gradientLoadingBar.fadeOut()
        }
    }

    private func export(to type: ExportType) {
        gradientLoadingBar.fadeIn()

        viewModel.export(type: type) { [weak self] err in
            self?.completion(err: err)
        }
    }

    private func openFile() {
        // TODO: Display file.
        UIApplication.shared.open(FileUtil.documentURL)
    }
}
