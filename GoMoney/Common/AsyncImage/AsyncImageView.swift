/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import UIKit

public class AsyncImageView: UIView {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)

    private lazy var loader = ImageLoader.shared

    public var defaultImage: UIImage? {
        didSet {
            imageView.image = defaultImage
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        addSubview(imageView)
        addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    public func load(imageURL: URL, defaultImage: UIImage? = UIImage(systemName: "fork.knife.circle")) {
        activityIndicator.startAnimating()
        loader.loadImage(imageURL) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(image):
                    self?.activityIndicator.stopAnimating()
                    self?.imageView.image = image

                case .failure:
                    self?.activityIndicator.stopAnimating()
                    self?.imageView.image = defaultImage
                }
            }
        }
    }

    public func load(imageURL: String?, defaultImage: UIImage? = nil) {
        if let imageURL = imageURL {
            if let url = URL(string: imageURL) {
                load(imageURL: url, defaultImage: defaultImage)
            } else {
                imageView.image = defaultImage
            }
        } else {
            imageView.image = defaultImage
        }
    }
}
