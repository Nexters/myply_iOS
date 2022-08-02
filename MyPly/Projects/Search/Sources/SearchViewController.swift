//
//  SearchViewController.swift
//  Search
//
//  Created by 최동규 on 2022/07/29.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit
import SnapKit

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
    
    private let keywordRepository: KeywordRepository
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    init(keywordRepository: KeywordRepository) {
        self.keywordRepository = keywordRepository
        super.init()
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.keywordRepository = DummyKeywordRepositoryImpl()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        initKeywordCollectionView()
        initDataSource()
        
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
}

// MARK: - Init View
extension SearchViewController {
    private func initKeywordCollectionView() {
        let layout = LeftAlignedCollectionViewFlowLayout()
        keywordCollectionView = .init(frame: .zero, collectionViewLayout: layout)
        keywordCollectionView.dataSource = keywordDataSource
    }
    
    private func initDataSource() {
        keywordDataSource = .init(collectionView: keywordCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueReusableCell(withReuseIdentifier: KeywordCell.Constants.identifier, for: indexPath)
        })
    }
    
    private func refreshKeywordCollectionView(with keywords: [Keyword]) {
        var snapShot = SnapShot()
        snapShot.appendSections([0])
        snapShot.appendItems(keywords.map({ $0.value }), toSection: 0)
        keywordDataSource.apply(snapShot)
    }
}

// MARK: - Init Data
extension SearchViewController {
    func initViewModel() {
        Task(priority: .userInitiated, operation: {
            let result = await keywordRepository.getKeywords()
            switch result {
            case .success(let keywords):
                self.refreshKeywordCollectionView(with: keywords)
            }
        })
    }
}

