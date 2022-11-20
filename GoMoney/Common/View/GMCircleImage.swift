import UIKit

class GMCircleImage: UIImageView {
    init(
        size: CGFloat,
        image: UIImage? = K.Image.user,
        border: CGFloat = 0,
        builder: ((GMCircleImage) -> Void)? = nil
    ) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = K.Color.contentBackground
        clipsToBounds = true

        anchor(width: size, height: size)

        layer.cornerRadius = size / 2
        if border > 0 {
            layer.borderWidth = border
            layer.borderColor = K.Color.borderOnBg.cgColor
        }

        self.image = image
        contentMode = .scaleAspectFill

        builder?(self)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
