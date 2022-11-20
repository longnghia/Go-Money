
import UIKit

class OnboardViewController: GMViewController {
    // MARK: Data

    private let onboardPages = [
        OnboardPageModel(imageName: "onboard_1", topicText: "Tracking", descriptionText: "Simply track your daily expenses."),
        OnboardPageModel(imageName: "onboard_2", topicText: "Categories", descriptionText: "Manage your categories's expenses."),
        OnboardPageModel(imageName: "onboard_3", topicText: "Analysis", descriptionText: "Easily find the status of your top expenses."),
        OnboardPageModel(imageName: "start", topicText: "Start Go Money!", descriptionText: "Start Go Money!"),
    ]

    // MARK: - Private properties

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(OnboardCell.self, forCellWithReuseIdentifier: OnboardCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var skipButton: GMButton = .init(text: "Skip", size: 14) {
        $0.addTarget(self, action: #selector(self.didTapSkipButton), for: .touchUpInside)
    }

    private lazy var startButton: GMButton = .init(text: "Start", size: 30) {
        $0.isHidden = true
        $0.addTarget(self, action: #selector(self.didTapStartButton), for: .touchUpInside)
    }

    private lazy var pageControl: UIPageControl = .build { pageControl in
        pageControl.currentPage = 0
        pageControl.numberOfPages = self.onboardPages.count
        pageControl.currentPageIndicatorTintColor = K.Color.primaryColor
        pageControl.pageIndicatorTintColor = K.Color.contentBackground
        pageControl.isUserInteractionEnabled = false
    }

    // MARK: - Life circle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Setup layout

    override func setupLayout() {
        super.setupLayout()

        view.backgroundColor = .white

        view.addSubviews(collectionView, skipButton, pageControl, startButton)

        collectionView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.rightAnchor
        )

        skipButton.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            right: view.rightAnchor,
            paddingRight: 32
        )

        pageControl.centerXToSuperview()
        pageControl.anchor(
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            paddingBottom: 8,
            height: 30
        )

        startButton.centerXToSuperview()
        startButton.anchor(bottom: pageControl.topAnchor, paddingBottom: 8)
    }

    // MARK: Actions

    @objc private func didTapSkipButton() {
        let indexPath = IndexPath(item: onboardPages.count - 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = onboardPages.count - 1
        skip()
    }

    @objc private func didTapStartButton() {
        skip()
    }

    private func skip() {
        UserDefaults.standard.set(true, forKey: UserDefaultKey.firstLaunch)

        let signInVC = SignInViewController()
        let navVC = UINavigationController(rootViewController: signInVC)
        navVC.modalPresentationStyle = .fullScreen

        if let delegate = view.window?.windowScene?.delegate as? SceneDelegate {
            delegate.window?.rootViewController = navVC
        }
    }
}

// MARK: - CollectionView delegate

extension OnboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func scrollViewWillEndDragging(_: UIScrollView, withVelocity _: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let xValue = targetContentOffset.pointee.x
        let pageNum = Int(xValue / view.frame.width)
        pageControl.currentPage = pageNum
        if pageNum != onboardPages.count - 1 {
            skipButton.isHidden = false
            startButton.isHidden = true
        } else {
            skipButton.isHidden = true
            startButton.isHidden = false
        }
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 0
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return onboardPages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardCell.identifier, for: indexPath) as? OnboardCell {
            let onboardPage = onboardPages[indexPath.row]
            cell.page = onboardPage
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func collectionView(_: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt _: IndexPath) {
        let onboardCell = cell as! OnboardCell
        onboardCell.onWillAppear(view)
    }
}
