import UIKit

public class CategoryPickerInputView: UIView {
    private(set) var didSelect: ((TransactionTag) -> Void)?

    private let incomeTags = TransactionTag.incomeTags
    private let expenseTags = TransactionTag.expenseTags

    lazy var collectionView: UICollectionView = {
        let numberOfItemsInSection = 4

        let spacing = CGFloat(20)
        let layout = UICollectionViewFlowLayout()

        let totalSpace = spacing * CGFloat(numberOfItemsInSection + 1)
        let itemWidth = CGFloat((UIScreen.main.bounds.width - totalSpace) / CGFloat(numberOfItemsInSection))
        let itemHeight = itemWidth

        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            CategoryPickerCell.self,
            forCellWithReuseIdentifier: CategoryPickerCell.identifier
        )
        return collectionView
    }()

    var type: ExpenseType = .expense
    var selectedTag: TransactionTag = .food

    init(
        type: ExpenseType = .expense,
        didSelect: ((TransactionTag) -> Void)? = nil
    ) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
        self.didSelect = didSelect
        self.type = type
        self.selectedTag = type == .expense ? expenseTags[0] : incomeTags[0]

        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        collectionView.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
    }
}

extension CategoryPickerInputView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return type == .expense ? expenseTags.count : incomeTags.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryPickerCell.identifier, for: indexPath) as? CategoryPickerCell {
            let tag = type == .expense ? expenseTags[indexPath.row] : incomeTags[indexPath.row]
            cell.transactionTag = tag
            return cell
        }
        return UICollectionViewCell()
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tag = type == .expense ? expenseTags[indexPath.row] : incomeTags[indexPath.row]
        didSelect?(tag)
    }
}

// MARK: Cell for collectionView

class CategoryPickerCell: UICollectionViewCell {
    static let identifier = "category_picker_cell"

    var transactionTag: TransactionTag? {
        didSet {
            if let transactionTag = transactionTag {
                bindView(tag: transactionTag)
            }
        }
    }

    lazy var image = GMExpenseIcon()
    lazy var label = GMLabel(style: .small, isCenter: true)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubviews(image, label)

        image.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75).isActive = true
        image.centerXToView(self)
        image.anchor(top: topAnchor)

        label.anchor(top: image.bottomAnchor, left: leftAnchor)
        label.centerXToView(self)
    }

    func bindView(tag: TransactionTag) {
        label.text = tag.getName()
        image.icon.image = UIImage(named: tag.getIcon()) ?? K.Image.bell
    }
}
