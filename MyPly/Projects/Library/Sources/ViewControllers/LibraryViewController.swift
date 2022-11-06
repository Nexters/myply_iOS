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
    
    private var cancellables = Set<AnyCancellable>()
    
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
        configurePublisher()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
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
    
    private func configurePublisher(){
        self.viewModel.refresh.send()
        
        viewModel.memos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }.store(in: &cancellables)

        collectionView.refreshControl?.isRefreshingPublisher
            .sink(receiveValue: { [weak self] isRefreshing in
                guard isRefreshing else { return }
                self?.viewModel.refresh.send(())
            })
            .store(in: &cancellables)
    }
}

extension LibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.memos.value.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let memo = viewModel.memos.value[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "libraryCell", for: indexPath) as! LibraryCollectionCell
        cell.title = memo.title ?? ""
        cell.memo = memo.body ?? ""
        cell.thumbnail = memo.thumbnailURL ?? ""
        
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
        let detailVC = LibraryDetailViewController.create() ?? UIViewController()
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
