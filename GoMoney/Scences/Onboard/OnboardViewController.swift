//
//  OnboardViewController.swift
//  GoMoney
//
//  Created by Golden Owl on 12/10/2022.
//

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
    
    private lazy var skipButton: GMButton = .build { skipButton in
        skipButton.setTitle("Skip", for: .normal)
        skipButton.gmSize = 14
        skipButton.addTarget(self, action: #selector(self.didTapSkipButton), for: .touchUpInside)
    }
    
    private lazy var startButton: GMButton = .build { startButton in
        startButton.setTitle("Start", for: .normal)
        startButton.isHidden = true
        startButton.gmSize = 30
        startButton.setTitleColor(.black, for: .normal)
        startButton.addTarget(self, action: #selector(self.didTapStartButton), for: .touchUpInside)
    }

    private lazy var pageControl: UIPageControl = .build { pageControl in
        pageControl.currentPage = 0
        pageControl.numberOfPages = self.onboardPages.count
        pageControl.currentPageIndicatorTintColor = K.Color.primaryColor
        pageControl.pageIndicatorTintColor = K.Color.contentBackground
        pageControl.isUserInteractionEnabled = false
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
            right: view.rightAnchor)
        
        skipButton.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            right: view.rightAnchor,
            paddingTop: 8,
            paddingRight: 32)

        pageControl.centerXToSuperview()
        pageControl.anchor(
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            paddingBottom: 8,
            height: 30)
        
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
        
    func skip() {
        UserDefaults.standard.set(true, forKey: UserDefaultKey.firstLaunch)
    
        let controller = SignInViewController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
    }
}

// MARK: - CollectionView delegate

extension OnboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardPages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardCell.identifier, for: indexPath)
        
        if let cell = cell as? OnboardCell {
            let onboardPage = onboardPages[indexPath.row]
            cell.page = onboardPage
            cell.onboardVC = self
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height - 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let onboardCell = cell as! OnboardCell
        onboardCell.onWillAppear(view)
    }
}
