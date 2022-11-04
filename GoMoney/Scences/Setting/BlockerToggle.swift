import UIKit

/// grasp toggle info
class BlockerToggle: Equatable {
    let toggle = UISwitch()
    let label: String
    let setting: Setting
    let subtitle: String?

    init(label: String? = nil, setting: Setting, subtitle: String? = nil) {
        self.label = label ?? setting.rawValue
        self.setting = setting
        self.subtitle = subtitle

        toggle.onTintColor = .primary
        toggle.tintColor = .gray.withAlphaComponent(0.2)
    }

    static func == (lhs: BlockerToggle, rhs: BlockerToggle) -> Bool {
        return lhs.toggle == rhs.toggle && lhs.label == rhs.label && lhs.setting == rhs.setting
    }
}
