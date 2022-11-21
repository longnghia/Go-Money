import UIKit

class SettingsViewController: GMMainViewController {
    private var settingChanged = false

    enum Section: String {
        case display, system, database, about

        var headerText: String? {
            switch self {
            case .display: return "Display"
            case .system: return "System"
            case .database: return "Data"
            case .about: return "App"
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
            action: #selector(dismissSettings)
        )

        doneButton.setTextAttributes(font: .nova(), color: .white)
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

    override func didTapBack() {
        if settingChanged {
            notifyDataDidChange()
        }
        super.didTapBack()
    }

    // MARK: - Methods

    private func initializeToggles() {
        let syncOnWifiToggle = BlockerToggle(
            setting: Setting.syncOnWifi)

        let enablePasswordToggle = BlockerToggle(
            setting: Setting.enablePassword)

        if let systemIndex = Section.getSectionIndex(.system) {
            toggles[systemIndex] = [
                0: enablePasswordToggle,
            ]
        }

        if let databaseIndex = Section.getSectionIndex(.database) {
            toggles[databaseIndex] = [
                1: syncOnWifiToggle,
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
                    for: .valueChanged
                )
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

        if toggle.setting == .enablePassword {
            enableBiometric(by: sender)
        } else {
            settings.setValue(sender.isOn, for: toggle.setting)
        }
    }

    private func enableBiometric(by sender: UISwitch) {
        if sender.isOn {
            BiometricService.shared.authenticate { [weak self] err in
                if let err = err {
                    switch err {
                    case .biometryNotEnrolled:
                        self?.showGotoSettingsAlert(message: err.message())

                    case .canceledBySystem, .canceledByUser:
                        break

                    default:
                        self?.errorAlert(message: err.message())
                    }

                    self?.settings.setValue(false, for: .enablePassword)
                    sender.setOn(false, animated: true)
                } else {
                    self?.settings.setValue(true, for: .enablePassword)
                }
            }
        } else {
            settings.setValue(false, for: .enablePassword)
        }
    }

    private func selectCurrency(at indexPath: IndexPath) {
        let currencyCell = (tableView.cellForRow(at: indexPath) as? SettingsTableViewAccessoryCell)

        let actions = CurrencyUnit.all.map { unit in
            let action = UIAlertAction(title: unit.rawValue, style: .default, handler: { _ in
                currencyCell?.accessoryLabelText = unit.rawValue
                self.settings.setValue(unit.rawValue, for: .currencyUnit)
                self.settingChanged = true
            })

            if action.title! == settings.getValue(for: .currencyUnit) as? String {
                action.setValue(true, forKey: "checked")
            }

            // just support "$" and "₫" currently.
            if action.title != CurrencyUnit.dollar.rawValue,
               action.title != CurrencyUnit.dong.rawValue
            {
                action.isEnabled = false
            }

            return action
        }

        alert(
            type: .actionSheet,
            with: nil,
            message: "Please Select a Currency Unit",
            actions: actions
        )
    }

    private func selectDateFormat(at indexPath: IndexPath) {
        let dateCell = (tableView.cellForRow(at: indexPath) as? SettingsTableViewAccessoryCell)
        let currentFormat = settings.getValue(for: .dateFormat) as? String
        let actions = DateFormat.all.map { unit in
            let format = unit.rawValue

            let action = UIAlertAction(title: format, style: .default, handler: { _ in
                dateCell?.accessoryLabelText = format
                self.settings.setValue(format, for: .dateFormat)
                self.settingChanged = true
            })

            if action.title! == currentFormat {
                action.setValue(true, forKey: "checked")
            }

            return action
        }

        alert(
            type: .actionSheet,
            with: nil,
            message: "Please Select a Day Format",
            actions: actions
        )
    }

    @objc private func dismissSettings() {
        didTapBack()
    }
}

// MARK: TableView

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return sections.count
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRows(for: sections[section])
    }

    func numberOfRows(for section: Section) -> Int {
        switch section {
        case .display: return 2
        case .system: return 1
        case .database: return 2
        case .about: return 2
        }
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            cell = setupToggleCell(indexPath: indexPath)

        case .database:
            if indexPath.row == 0 {
                let syncCell = SettingsTableViewAccessoryCell(style: .value1, reuseIdentifier: "accessoryCell")
                syncCell.labelText = Setting.intervalSync.rawValue

                let currentInterval = settings.getValue(for: .intervalSync) as? Int
                let syncTime = SyncInterval.all.first(where: {
                    $0.rawValue == currentInterval
                })
                if let syncTime = syncTime {
                    syncCell.accessoryLabelText = syncTime.getTitle()
                } else {
                    syncCell.accessoryLabelText = "Not set"
                }

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

    func tableView(_: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if sections[section] == .database {
            let lastSync = getLastSync()

            if lastSync.isEmpty {
                return nil
            }

            let footer = SettingsFooterView()
            footer.textLabel.text = "Last synced: \(lastSync)"

            return footer
        }
        return nil
    }

    private func setupToggleCell(indexPath: IndexPath) -> SettingsTableViewToggleCell {
        let toggle = toggleForIndexPath(indexPath)
        let cell = SettingsTableViewToggleCell(style: .subtitle, reuseIdentifier: "toggleCell", toggle: toggle)

        return cell
    }

    private func toggleForIndexPath(_ indexPath: IndexPath) -> BlockerToggle {
        guard let toggle = toggles[indexPath.section]?[indexPath.row] else {
            return BlockerToggle(label: "Error", setting: Setting.syncOnWifi)
        }
        return toggle
    }

    func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].headerText
    }

    func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch sections[section] {
        case .display:
            return 70
        case .database:
            return 50
        default:
            return 30
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch sections[indexPath.section] {
        case .display:
            switch indexPath.row {
            case 0:
                selectCurrency(at: indexPath)
            case 1:
                selectDateFormat(at: indexPath)
            default:
                break
            }
        case .system:
            break
        case .database:
            if indexPath.row == 0 {
                showSyncActionSheet(at: indexPath)
            }
        case .about:
            switch indexPath.row {
            case 0:
                openURL(K.URL.github)
            default:
                openURL(K.URL.testFlight)
            }
        }
    }
}

extension SettingsViewController {
    func getLastSync() -> String {
        guard let lastSyncEpoch = settings.getValue(for: .lastSync) as? Double else {
            return ""
        }

        let date = Date(timeIntervalSince1970: lastSyncEpoch)
        return date.timeAgoDisplay()
    }

    func showSyncActionSheet(at indexPath: IndexPath) {
        let syncIntervalCell = (tableView.cellForRow(at: indexPath) as? SettingsTableViewAccessoryCell)

        let actions = SyncInterval.all.map { syncTime in
            UIAlertAction(title: syncTime.getTitle(), style: .default, handler: { _ in
                syncIntervalCell?.accessoryLabelText = "\(syncTime.getTitle())"
                self.settings.setValue(syncTime.rawValue, for: .intervalSync)
            })
        }

        alert(
            type: .actionSheet,
            with: nil,
            message: "Choose sync interval time",
            actions: actions,
            showCancel: true
        )
    }
}
