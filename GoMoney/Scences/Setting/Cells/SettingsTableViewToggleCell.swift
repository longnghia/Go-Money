import UIKit

class SettingsTableViewToggleCell: SettingsTableViewCell {
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, toggle: BlockerToggle) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        textLabel?.numberOfLines = 0
        textLabel?.text = toggle.label
        textLabel?.textColor = .black
        layoutMargins = UIEdgeInsets.zero

        accessoryView = PaddedSwitch(switchView: toggle.toggle)
        selectionStyle = .none
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class PaddedSwitch: UIView {
    private static let Padding: CGFloat = 8

    convenience init(switchView: UISwitch) {
        self.init(frame: .zero)

        addSubview(switchView)

        frame.size = CGSize(
            width: switchView.frame.width + PaddedSwitch.Padding,
            height: switchView.frame.height
        )
        switchView.frame.origin = CGPoint(x: PaddedSwitch.Padding, y: 0)
    }
}
