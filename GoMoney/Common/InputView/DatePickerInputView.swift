/// https://github.com/sag333ar/InputViews

import UIKit

public class DatePickerInputView: UIView {
    private(set) var didSelect: ((Date) -> Void)?
    private(set) var pickerMode: UIDatePicker.Mode = .dateAndTime

    lazy var pickerView: UIDatePicker = {
        let pickerView = UIDatePicker()
        pickerView.preferredDatePickerStyle = .wheels
        pickerView.locale = K.Theme.locale
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()

    init(
        mode: UIDatePicker.Mode,
        didSelect: ((Date) -> Void)? = nil
    ) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
        self.didSelect = didSelect
        pickerMode = mode
        setupView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(pickerView)

        pickerView.datePickerMode = pickerMode
        pickerView.addTarget(self, action: #selector(didChangeTheDate), for: .valueChanged)
        pickerView.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
        pickerView.backgroundColor = .white
        pickerView.date = Date()

        layer.cornerRadius = 8
    }

    @objc func didChangeTheDate() {
        didSelect?(pickerView.date)
    }
}
