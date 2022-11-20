import UIKit

class IconCollectionVC: GMMainViewController {
    // MARK: - Properties

    private let viewModel = IconCollectionViewModel()

    var didSelect: ((String) -> Void)?

    private let headers = ["Default", "Downloaded"]

    // MARK: - Views

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

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
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            IconPickerCell.self,
            forCellWithReuseIdentifier: IconPickerCell.identifier
        )

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
    }

    override func setupLayout() {
        super.setupLayout()
        view.backgroundColor = .white
        view.addSubviews(searchBar, collectionView)

        searchBar.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            height: 56
        )

        collectionView.anchor(
            top: searchBar.bottomAnchor,
            left: searchBar.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: searchBar.rightAnchor,
            paddingTop: 32
        )
    }

    private func setupViewModel() {
        viewModel.filterTags(by: "") { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension IconCollectionVC: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.defaultIcons.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconPickerCell.identifier, for: indexPath) as? IconPickerCell {
            let src = viewModel.defaultIcons[indexPath.row]
            cell.bindView(src: src)

            return cell
        }
        return UICollectionViewCell()
    }

    public func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let src = viewModel.defaultIcons[indexPath.row]
        didSelect?(src)
        dismiss(animated: true)
    }
}

extension IconCollectionVC: UISearchBarDelegate {
    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        viewModel.filterTags(by: searchText) { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}
