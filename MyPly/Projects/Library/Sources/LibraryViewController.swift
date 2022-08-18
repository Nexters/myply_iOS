//
//  LibraryViewController.swift
//  Library
//
//  Created by 최동규 on 2022/07/29.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

open class LibraryViewController: UIViewController {
    
    // MARK: UI
    
    private let headerView = UIView().then {
        $0.backgroundColor = CommonUIAsset.begie.color
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "보관함"
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.textColor = CommonUIAsset.gray80.color
    }
    
    private let descLabel = UILabel().then {
        $0.text = "플레이리스트가 아직 없어요."
        $0.font = .systemFont(ofSize: 14, weight: .bold)
        $0.textColor = CommonUIAsset.gray60.color
    }
    
    private var collectionView: UICollectionView!
    
    // MARK: Property
    
    private let viewModel: LibraryViewModel
    
    init(viewModel: LibraryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        initLayout()
    }
}

extension LibraryViewController {
    public static func create() -> LibraryViewController? {
        let viewModel = LibraryViewModel()
        let libraryVC = LibraryViewController(viewModel: viewModel)
        
        return libraryVC
    }
    
    private func addViews(){
        view.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(descLabel)
        
        view.addSubview(collectionView)
    }
    
    private func initLayout(){
        initCollectionView()
        addViews()
        
        view.backgroundColor = CommonUIAsset.begie.color
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(9)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
        }
        
        descLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.bottom.equalTo(-18)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func initCollectionView() {
        let flowLayout = UICollectionViewFlowLayout().then {
            $0.scrollDirection = .vertical
            $0.minimumLineSpacing = 0
            $0.minimumInteritemSpacing = 0
        }
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
            $0.backgroundColor = CommonUIAsset.begie.color
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.register(LibraryCollectionCell.self, forCellWithReuseIdentifier: "libraryCell")
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension LibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5 // test
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "libraryCell", for: indexPath) as! LibraryCollectionCell
        
        return cell
    }
}

extension LibraryViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.size.width
        let height: CGFloat = 196
        return CGSize(width: width, height: height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // TODO: 로직 변경
        
        let detailVC = LibraryDetailViewController.create() ?? UIViewController()
        detailVC.modalPresentationStyle = .overFullScreen
        present(detailVC, animated: true)
    }
}
