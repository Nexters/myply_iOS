//
//  SearchViewController.swift
//  Search
//
//  Created by 최동규 on 2022/07/29.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit
import SnapKit
import Search
import Combine

typealias KeywordDataSource = UICollectionViewDiffableDataSource<Int, String>
typealias SnapShot = NSDiffableDataSourceSnapshot<Int, String>

open class SearchViewController: UIViewController {
    private var titleLabel: UILabel = {
        $0.text = "검색"
        $0.textColor = UIColor.gray90
        return $0
    }(UILabel())
    
    private var searchField: UITextField = {
        $0.clearButtonMode = .always
        $0.setPlaceHolderColor(UIColor.gray50)
        $0.backgroundColor = .white
        $0.placeholder = "검색어를 입력해주세요."
        
        let leftView = UIImageView(image: UIImage.search)
        
        $0.leftViewMode = .always
        $0.leftView = leftView
        return $0
    }(UITextField())
    
    private var bestSearchKeywordsTitle: UILabel = {
        $0.text = "마이플리 유저의 인기 검색어"
        $0.textColor = UIColor.gray70
        return $0
    }(UILabel())
    
    private var keywordCollectionView: UICollectionView!
    private var keywordDataSource: KeywordDataSource!
    private var cancellable: Set<AnyCancellable> = .init()
    
    private let viewModel: SearchViewModel
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let repository = DummyKeywordRepositoryImpl()
        let fetchKeywordUseCAse = DefaultFetchKeywordsUseCase(repository: repository)
        self.viewModel = DefaultSearchViewModel(fetchKeywordUseCase: fetchKeywordUseCAse)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initKeywordCollectionView()
        initView()
        fetchKeyword()
        bindViewModel()
    }
}

// MARK: - Init View
extension SearchViewController {
    private func initView() {
        view.backgroundColor = UIColor.begie
        
        view.addSubview(titleLabel)
        view.addSubview(searchField)
        view.addSubview(bestSearchKeywordsTitle)
        view.addSubview(keywordCollectionView)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(view.safeAreaInsets.top).offset(9)
            make.height.equalTo(56)
        }
        
        searchField.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-40)
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        bestSearchKeywordsTitle.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-40)
            make.top.equalTo(searchField.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
        
        keywordCollectionView.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-40)
            make.top.equalTo(bestSearchKeywordsTitle.snp.bottom).offset(12)
            let height = view.bounds.height -            bestSearchKeywordsTitle.frame.origin.y
            make.height.equalTo(height)
            make.centerX.equalToSuperview()
        }
    }
    
    private func initKeywordCollectionView() {
        let layout = LeftAlignedCollectionViewFlowLayout()
        keywordCollectionView = .init(frame: .zero, collectionViewLayout: layout)
        keywordCollectionView.delegate = self
        keywordCollectionView.dataSource = keywordDataSource
        keywordCollectionView.backgroundColor = .clear
        
        let nibName = UINib(nibName: "KeywordCell", bundle: Bundle.main)
        keywordCollectionView.register(nibName, forCellWithReuseIdentifier: KeywordCell.Constants.reuseIdentifier)
        
        initDataSource()
    }
    
    private func initDataSource() {
        keywordDataSource = .init(collectionView: keywordCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeywordCell.Constants.reuseIdentifier, for: indexPath)
            
            guard let keywordCell = cell as? KeywordCell else {
                return cell
            }
            
            let index = indexPath.row
            guard let keyword = self.viewModel.keywords?[index] else {
                return cell
            }
            keywordCell.setKeyword(with: keyword)
            return keywordCell
        })
    }
    
    
    private func refreshKeywordCollectionView(with keywords: [Keyword]) {
        print("refrsh keyword collectionview with: \(keywords)")
        var snapShot = SnapShot()
        snapShot.appendSections([0])
        snapShot.appendItems(keywords.map({ $0.value }), toSection: 0)
        keywordDataSource.apply(snapShot, animatingDifferences: false, completion: nil)
    }
}

// MARK: - Init Data
extension SearchViewController {
    func fetchKeyword() {
        Task(priority: .userInitiated, operation: {
            guard (try? await viewModel.fetchKeyword()) != nil else {
                return
            }
        })
    }
    
    func bindViewModel() {
        viewModel.keywordsPublisher
            .sink { keywords in
                guard let keywords = keywords else { return }
                self.refreshKeywordCollectionView(with: keywords)
                self.keywordCollectionView.reloadData()
            }.store(in: &cancellable)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let keyword = viewModel.keywords?[indexPath.row]
        else { return .zero }
        
        let label = UILabel()
        label.text = KeywordText(keyword: keyword).value
        label.font = .init(name: "Pretendard", size: 14)
        label.sizeToFit()
        
        return label.frame.size
    }
}

