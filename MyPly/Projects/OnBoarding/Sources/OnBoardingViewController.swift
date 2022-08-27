//
//  OnBoardingViewController.swift
//  OnBoarding
//
//  Created by 최모지 on 2022/07/30.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import SignUp

open class OnBoardingViewController: UIViewController {
    
    // MARK: UI
    
    private var collectionView: UICollectionView!

    private let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.backgroundColor = CommonUIAsset.greenDark.color
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    private lazy var pageControl = UIPageControl().then {
        $0.numberOfPages = onBoardingModels.count
        $0.currentPage = 0
        $0.pageIndicatorTintColor = CommonUIAsset.gray50.color
        $0.currentPageIndicatorTintColor = CommonUIAsset.greenLight.color
    }
    
    // MARK: Property
    
    private let onBoardingModels: [OnBoardingModel] = OnBoardingModel.modelList()
    
    private var currentIndex: Int = 0 {
        didSet {
            setButtonTitle()
        }
    }
    
    private let viewModel: OnBoardingViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: OnBoardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        initLayout()
        configureNextButton()
    }
}

extension OnBoardingViewController {
    public static func create() -> OnBoardingViewController? {
        let viewModel = OnBoardingViewModel()
        let onBoardingVC = OnBoardingViewController(viewModel: viewModel)
        
        return onBoardingVC
    }
    
    private func addViews(){
        view.addSubview(collectionView)
        view.addSubview(nextButton)
        view.addSubview(pageControl)
    }

    private func initLayout(){
        initCollectionView()
        addViews()
        
        self.view.backgroundColor = CommonUIAsset.begie.color
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(132)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(455)
        }
        
        pageControl.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(32)
            $0.centerX.equalTo(collectionView.snp.centerX)
        }

        nextButton.snp.makeConstraints {
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.bottom.equalTo(-56)
            $0.height.equalTo(56)
        }
    }

    private func initCollectionView(){
        let flowLayout = UICollectionViewFlowLayout().then {
            $0.scrollDirection = .horizontal
            $0.minimumLineSpacing = 0
            $0.minimumInteritemSpacing = 0
        }

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.isPagingEnabled = true
            $0.register(OnBoardingCell.self, forCellWithReuseIdentifier: "onBoardingCell")
        }

        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setButtonTitle(){
        nextButton.setTitle(currentIndex == onBoardingModels.count - 1 ? "시작하기" : "다음", for: .normal)
    }
}

extension OnBoardingViewController {
    private func configureNextButton() {
        nextButton.tapPublisher
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                
                if self.currentIndex != self.onBoardingModels.count-1 {
                    self.scrollToIndex(index: self.currentIndex+1)
                } else {
                    guard let signUpVC = SignUpViewController.create() else { return }
                    
                    let navigationController = UINavigationController()
                    navigationController.pushViewController(signUpVC, animated: false)
                    navigationController.modalPresentationStyle = .fullScreen
                    
                    self.present(navigationController, animated: true)
                }
            })
            .store(in: &cancellables)
    }
    
    func scrollToIndex(index:Int) {
        let rect = self.collectionView.layoutAttributesForItem(at:IndexPath(row: index, section: 0))?.frame
        self.collectionView.scrollRectToVisible(rect!, animated: true)
        self.pageControl.currentPage = index
        self.currentIndex += 1
    }
}

extension OnBoardingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onBoardingModels.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "onBoardingCell", for: indexPath) as! OnBoardingCell
        
        cell.desc = onBoardingModels[indexPath.row].desc
        cell.image = onBoardingModels[indexPath.row].imageName
        
        return cell
    }
}

extension OnBoardingViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.size.width
        let height: CGFloat = 519
        return CGSize(width: width, height: height)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = self.collectionView.contentOffset
        visibleRect.size = self.collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = self.collectionView.indexPathForItem(at: visiblePoint) else { return }
        self.currentIndex = indexPath.row
        self.pageControl.currentPage = currentIndex
    }
}
