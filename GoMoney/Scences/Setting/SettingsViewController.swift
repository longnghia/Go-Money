import UIKit

class SettingsViewController: GMMainViewController {
    enum Section: String {
        case display, system, database, about

        var headerText: String? {
            switch self {
            case .display: return "Display"
            case .system: return "System"
            case .database: return "Database"
            case .about: return "GoMoney"
            }
        }

        static let sections: [Section] = [.display, .system, .database, .about]

        static func getSectionIndex(_ section: Section) -> Int? {
            return sections.firstIndex(where: { $0 == section })
        }
    }

    private let sections = Section.sections

    // UISwitchs in section and row
    private var toggles = [Int: [Int: BlockerToggle]]()

    private let settings = SettingsManager.shared

    // MARK: - Views

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.allowsSelection = true
        tableView.backgroundColor = K.Color.background
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(SettingsTableViewAccessoryCell.self, forCellReuseIdentifier: "accessoryCell")
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "settingSell")
        tableView.register(SettingsTableViewToggleCell.self, forCellReuseIdentifier: "toggleCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var doneButton: UIBarButtonItem = {
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(dismissSettings))

        return doneButton
    }()

    // MARK: - LifeCircle

    override func configureNavigation() {
        super.configureNavigation()

        navigationItem.rightBarButtonItem = doneButton
    }

    override func getTitle() -> String? {
        return "Settings"
    }

    override func setupLayout() {
        super.setupLayout()

        view.addSubview(tableView)
        tableView.fillSuperview()

        initializeToggles()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    // MARK: - Methods

    private func initializeToggles() {
        let syncOnWifiToggle = BlockerToggle(
            setting: Setting.syncOnWifi)

        let showOnStatusBarToggle = BlockerToggle(
            setting: Setting.showOnStatusBar)

        let enablePasswordToggle = BlockerToggle(
            setting: Setting.enablePassword)

        if let databaseIndex = Section.getSectionIndex(.system) {
            toggles[databaseIndex] = [
                0: enablePasswordToggle,
            ]
        }

        if let databaseIndex = Section.getSectionIndex(.database) {
            toggles[databaseIndex] = [
                1: syncOnWifiToggle,
                2: showOnStatusBarToggle,
            ]
        }

        setTogglesValue()
    }

    private func setTogglesValue() {
        for (sectionIndex, toggleArray) in toggles {
            for (cellIndex, blockerToggle) in toggleArray {
                let toggle = blockerToggle.toggle
                toggle.addTarget(
                    self,
                    action: #selector(toggleSwitched(_:)),
                    for: .valueChanged)
                toggle.isOn = settings.getValue(for: blockerToggle.setting) as? Bool ?? false
                toggles[sectionIndex]?[cellIndex] = blockerToggle
            }
        }
    }

    @objc private func toggleSwitched(_ sender: UISwitch) {
        let toggle = toggles
            .values.filter
            { $0.values.filter { $0.toggle == sender } != [] }[0]
            .values.filter
            { $0.toggle == sender }[0]

        settings.setValue(sender.isOn, for: toggle.setting)
    }

    @objc private func dismissSettings() {
        didTapBack()
    }
}

// MARK: TableView

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRows(for: sections[section])
    }

    func numberOfRows(for section: Section) -> Int {
        switch section {
        case .display: return 2
        case .system: return 1
        case .database: return 3
        case .about: return 2
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell

        switch sections[indexPath.section] {
        case .display:
            let label: String
            let accessoryLabel: String
            if indexPath.row == 0 {
                label = Setting.currencyUnit.rawValue
                accessoryLabel = settings.getValue(for: .currencyUnit) as? String ?? ""
            } else {
                label = Setting.dateFormat.rawValue
                accessoryLabel = settings.getValue(for: .dateFormat) as? String ?? ""
            }

            let displayCell = SettingsTableViewAccessoryCell(style: .value1, reuseIdentifier: "accessoryCell")
            displayCell.labelText = label
            displayCell.accessoryLabelText = accessoryLabel
            cell = displayCell

            cell = displayCell
        case .system:
            let systemCell = SettingsTableViewAccessoryCell(style: .value1, reuseIdentifier: "accessoryCell")
            systemCell.labelText = Setting.enablePassword.rawValue
            systemCell.accessoryLabelText = settings.getValue(for: .enablePassword) as? String ?? ""
            cell = systemCell
        case .database:
            if indexPath.row == 0 {
                let syncCell = SettingsTableViewAccessoryCell(style: .value1, reuseIdentifier: "accessoryCell")
                syncCell.labelText = Setting.intervalSync.rawValue
                syncCell.accessoryLabelText = String(settings.getValue(for: .intervalSync) as? Int ?? 0)
                cell = syncCell
            } else {
                cell = setupToggleCell(indexPath: indexPath)
            }
        case .about:
            switch indexPath.row {
            case 0:
                let aboutCell = SettingsTableViewAccessoryCell(style: .value1, reuseIdentifier: "accessoryCell")
                aboutCell.labelText = "About GoMoney"
                cell = aboutCell
            default:
                let rateCell = SettingsTableViewAccessoryCell(style: .value1, reuseIdentifier: "accessoryCell")
                rateCell.labelText = "Rate GoMoney"
                cell = rateCell
            }
        }

        cell.textLabel?.textColor = .black
        cell.layoutMargins = UIEdgeInsets.zero
        cell.detailTextLabel?.textColor = .gray

        return cell
    }

    private func setupToggleCell(indexPath: IndexPath) -> SettingsTableViewToggleCell {
        let toggle = toggleForIndexPath(indexPath)
        let cell = SettingsTableViewToggleCell(style: .subtitle, reuseIdentifier: "toggleCell", toggle: toggle)

        return cell
    }

    private func toggleForIndexPath(_ indexPath: IndexPath) -> BlockerToggle {
        guard let toggle = toggles[indexPath.section]?[indexPath.row]
        else { return BlockerToggle(label: "Error", setting: Setting.syncOnWifi) }
        return toggle
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].headerText
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sections[section] == .database ? 50 : 30
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch sections[indexPath.section] {
        case .display:
            switch indexPath.row {
            case 0:
                print("Change currency format")
            default:
                print("Change date format")
            }
        case .system:
            break
        case .database:
            if indexPath.row == 0 {
                print("Set sync interval")
            }
        case .about:
            switch indexPath.row {
            case 0:
                print("About us")
            default:
                print("Rate us")
            }
        }
    }
}
