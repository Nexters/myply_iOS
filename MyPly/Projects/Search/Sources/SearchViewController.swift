//
//  SearchViewController.swift
//  Search
//
//  Created by 최동규 on 2022/07/29.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit
import SnapKit
import Combine
import CommonUI
import Model


// MARK: - typealias Keyword
typealias KeywordDataSource = UICollectionViewDiffableDataSource<Int, String>
typealias KeywordSnapShot = NSDiffableDataSourceSnapshot<Int, String>

// MARK: - typealias SearchResult
typealias SearchResultDatasource = UICollectionViewDiffableDataSource<Int, String>
typealias SearchResultSnapShot = NSDiffableDataSourceSnapshot<Int, String>

open class SearchViewController: UIViewController {
    private var titleLabel: UILabel = {
        $0.text = "검색"
        $0.textColor = UIColor.gray90
        return $0
    }(UILabel())
    
    private var searchField: SearchField = {
        $0.clearButtonMode = .always
        $0.setPlaceHolderColor(UIColor.gray50)
        $0.backgroundColor = .white
        $0.placeholder = "검색어를 입력해주세요."
        return $0
    }(SearchField())
    
    private var bestSearchKeywordsTitle: UILabel = {
        $0.text = "마이플리 유저의 인기 검색어"
        $0.textColor = UIColor.gray70
        return $0
    }(UILabel())
    
    private var emptyView: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .fill
        
        let emptyImageView = UIImageView()
        let emptyLabel = UILabel()
        emptyLabel.text = "‘어쩔티비’ 에 대한 검색 결과가 없어요.\n다른 키워드로 검색해 보세요."
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = .zero
        
        $0.addArrangedSubview(emptyImageView)
        $0.addArrangedSubview(emptyLabel)
        $0.isHidden = true
        return $0
    }(UIStackView())
    
    private var keywordCollectionView: UICollectionView!
    private var keywordDataSource: KeywordDataSource!
    
    private var searchResultCollectionView: UICollectionView!
    private var searchResultDataSource: SearchResultDatasource!
    private var searchResultLayoutDelegate: UICollectionViewDelegateFlowLayout = SearchResultCollectionViewDelegate()
    
    private var keywordColors: [UIColor] = .init()
    private let viewModel: SearchViewModel
    private var cancellable: Set<AnyCancellable> = .init()
    
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let repository = DummyKeywordRepositoryImpl()
        let fetchKeywordUseCase = DefaultFetchKeywordsUseCase(repository: repository)
        
        let playlistRepository = DummyPlaylistRepositoryImpl()
        let searchPlaylistUseCase = DefaultSearchPlaylistUsecase(repository: playlistRepository)
        self.viewModel = DefaultSearchViewModel(fetchKeywordUseCase: fetchKeywordUseCase, searchPlaylistUseCase: searchPlaylistUseCase)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initKeywordCollectionView()
        initSearchResultCollectionView()
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
        view.addSubview(searchResultCollectionView)
        view.addSubview(emptyView)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
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
            make.centerX.equalToSuperview()
            make.top.equalTo(bestSearchKeywordsTitle.snp.bottom).offset(12)
        }
        
        searchResultCollectionView.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-40)
            make.top.equalTo(bestSearchKeywordsTitle.snp.bottom).offset(12)
            let height = view.bounds.height -            bestSearchKeywordsTitle.frame.origin.y
            make.height.equalTo(height)
            make.centerX.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    private func initSearchResultCollectionView() {
        // TODO: SearchResultCollectionView 구현
        let layout = LeftAlignedCollectionViewFlowLayout()
        searchResultCollectionView = .init(frame: .zero, collectionViewLayout: layout)
        searchResultCollectionView.delegate = searchResultLayoutDelegate
        searchResultCollectionView.dataSource = searchResultDataSource
        searchResultCollectionView.backgroundColor = .clear
        
        let xib = UINib(nibName: PlaylistCell.identifier, bundle: CommonUIResources.bundle)
        searchResultCollectionView.register(xib, forCellWithReuseIdentifier: PlaylistCell.identifier)
        
        initSearchResultDataSource()
    }
    
    private func initSearchResultDataSource() {
        // TODO: initSearchResultDataSource() 구현
        searchResultDataSource = .init(collectionView: searchResultCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistCell.identifier, for: indexPath) as? PlaylistCell else { return UICollectionViewCell() }
            cell.backgroundColor = .white
            return cell
        })
    }
    
    private func initKeywordCollectionView() {
        let layout = LeftAlignedCollectionViewFlowLayout()
        keywordCollectionView = .init(frame: .zero, collectionViewLayout: layout)
        keywordCollectionView.delegate = self
        keywordCollectionView.dataSource = keywordDataSource
        keywordCollectionView.backgroundColor = .clear
        
        let nibName = UINib(nibName: "KeywordCell", bundle: .init(for: KeywordCell.self))
        keywordCollectionView.register(nibName, forCellWithReuseIdentifier: KeywordCell.Constants.reuseIdentifier)
        
        initKeywordDataSource()
    }
    
    private func initKeywordDataSource() {
        keywordDataSource = .init(collectionView: keywordCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeywordCell.Constants.reuseIdentifier, for: indexPath)
            
            guard let keywordCell = cell as? KeywordCell else {
                return cell
            }
            
            let index = indexPath.row
            if let keyword = self.viewModel.keywords?[index] {
                keywordCell.setKeyword(with: keyword)
            }
            
            if let backgroundColor = self.keywordColors[safe: index]  {
                keywordCell.setBackgroundColor(backgroundColor)
            }
            return keywordCell
        })
    }
    
    
    private func refreshKeywordCollectionView(with keywords: [Keyword]) {
        var snapShot = KeywordSnapShot()
        snapShot.appendSections([0])
        snapShot.appendItems(keywords.map({ $0.value }), toSection: 0)
        keywordDataSource.apply(snapShot, animatingDifferences: false, completion: nil)
    }
    
    private func refreshSearchResultCollectionView(with playlists: [Playlist]) {
        var snapShot = SearchResultSnapShot()
        snapShot.appendSections([0])
        snapShot.appendItems(playlists.map({ $0.youtubeVideoID }))
        searchResultDataSource.apply(snapShot, animatingDifferences: false, completion: nil)
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
            .compactMap({ $0 })
            .sink { keywords in
                self.keywordColors = KeywordColorFactory.create(keywords: keywords)
                self.refreshKeywordCollectionView(with: keywords)
            }.store(in: &cancellable)
        
        searchField.textPublisher
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .compactMap({ $0 })
            .sink { [weak self] searchParam in
                if searchParam.isEmptyOrBlank {
                    self?.searchResultCollectionView.isHidden = true
                    self?.keywordCollectionView.isHidden = false
                    self?.emptyView.isHidden = true
                    return
                }
                self?.viewModel.search(param: searchParam)
            }.store(in: &cancellable)
        
        viewModel.searchResultPublisher
            .compactMap({ $0 })
            .receive(on: RunLoop.main)
            .sink { [weak self] playlists in
                self?.emptyView.isHidden = !playlists.isEmpty
                self?.searchResultCollectionView.isHidden = false
                self?.keywordCollectionView.isHidden = true
                
                self?.refreshSearchResultCollectionView(with: playlists)
            }.store(in: &cancellable)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout : KeywordCell 크기 설정
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let keyword = viewModel.keywords?[indexPath.row]
        else { return .zero }
        
        let label = UILabel()
        label.text = KeywordText(keyword: keyword).value
        label.font = .init(name: "Pretendard", size: 14)
        label.sizeToFit()
        return .init(width: label.frame.width + 24, height: label.frame.height + 11)
    }
}

// MARK: SearchResultCollectionViewDeleate : Playlist cell 크기 설정
class SearchResultCollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.bounds.width, height: 284)
    }
}

