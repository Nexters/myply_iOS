//
//  SelectKeywordView.swift
//  CommonUI
//
//  Created by nylah.j on 2022/08/27.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit
import Model
import Combine

typealias KeywordDataSource = UICollectionViewDiffableDataSource<Int, Keyword>
typealias KeywordSnapShot = NSDiffableDataSourceSnapshot<Int, Keyword>

class SelectKeywordView: UIView {
    private var cancellableSet: Set<AnyCancellable> = .init()
    
    @IBOutlet weak var keywordCollectionView: UICollectionView!
    @IBOutlet weak var selectedCollectionView: UICollectionView!
    @IBOutlet weak var bottomView: UIView!
    
    var keywordDataSource: KeywordDataSource!
    var selectedKeywordDataSource: KeywordDataSource!
    
    var viewModel: SelectKeywordViewModel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder: NSCoder) {
        let memberRepository = DummyMemberRepository()
        let updateKeywordUsecase = DefaultUpdateKeywordUseCase(repository: memberRepository)
        
        let keywordRepository = DummyKeywordRepositoryImpl()
        let fetchKeywordUseCase = DefaultFetchKeywordsUseCase(repository: keywordRepository)
        viewModel = SelectKeywordViewModel(fetchKeywordsUseCase: fetchKeywordUseCase, updateKeywordUseCase: updateKeywordUsecase)
        
        super.init(coder: coder)
        // TODO: DefaultMemberRepository로 수정해야public 한다.
    }
    
    private func bindViewModel() {
        viewModel.keywordsSubject
            .map({ $0 ?? [] })
            .sink { _ in }
            receiveValue: { keywords in
                self.updateKeywords(with: keywords)
            }.store(in: &cancellableSet)
        
        viewModel.selectedKeywordsSubject
            .map({ $0 ?? [] })
            .sink { _ in }
            receiveValue: { keywords in
                self.updateSelectedKeywords(with: keywords)
            }.store(in: &cancellableSet)
        
        viewModel.isEmptySelected
            .assign(to: \.isHidden, on: bottomView!)
            .store(in: &cancellableSet)
    }
    
    private func updateKeywords(with keywords: Keywords) {
        var snapShot = KeywordSnapShot()
        snapShot.appendSections([0])
        snapShot.appendItems(keywords, toSection: 0)
        keywordDataSource.apply(snapShot)
    }
    
    private func updateSelectedKeywords(with keywords: Keywords) {
        var snapShot = KeywordSnapShot()
        snapShot.appendSections([0])
        snapShot.appendItems(keywords, toSection: 0)
        keywordDataSource.apply(snapShot)
    }
}

extension SelectKeywordView {
    private func initKeywordDataSource() {
        let keywordNib = UINib(nibName: KeywordCell.nibName, bundle: .init(for: KeywordCell.self))
        let cellRegistration = UICollectionView.CellRegistration<KeywordCell, Keyword>(cellNib: keywordNib) { cell, indexPath, keyword in
            cell.setKeyword(with: keyword)
        }
        
        keywordDataSource = .init(collectionView: keywordCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let index = indexPath.item
            let keyword = self.viewModel.keywords?[index]
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: keyword!)
        })
    }
    
    private func initSelectedKeywordsDataSource() {
        let keywordNib = UINib(nibName: KeywordCell.nibName, bundle: .init(for: KeywordCell.self))
        let cellRegistration = UICollectionView.CellRegistration<KeywordCell, Keyword>(cellNib: keywordNib) { cell, indexPath, itemIdentifier in
            guard let keyword = self.viewModel.selectedKeywords?[indexPath.item] else { return }
            cell.setKeyword(with: keyword)
        }
        selectedKeywordDataSource = .init(collectionView: selectedCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let index = indexPath.item
            let keyword = self.viewModel.keywords?[index]
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: keyword!)
        })
    }
}

extension SelectKeywordView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let keyword = keywordDataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        viewModel.toggle(keyword: keyword)
    }
}