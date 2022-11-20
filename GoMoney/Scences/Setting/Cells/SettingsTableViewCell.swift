import UIKit

class SettingsTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .gray
        contentView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)

        textLabel?.font = .nova()
        detailTextLabel?.font = .nova()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
