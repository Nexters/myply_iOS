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
import SwiftUI
import SnapKit

typealias KeywordDataSource = UICollectionViewDiffableDataSource<Int, Keyword>
typealias KeywordSnapShot = NSDiffableDataSourceSnapshot<Int, Keyword>

open class SelectKeywordView: UIView {
    private var cancellableSet: Set<AnyCancellable> = .init()
    
    @IBOutlet weak var keywordCollectionView: UICollectionView!
    @IBOutlet weak var selectedCollectionView: UICollectionView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var startButton: UIButton!
    
    var keywordDataSource: KeywordDataSource!
    var selectedKeywordDataSource: KeywordDataSource!
    private var keywordColors: [Keyword: UIColor] = .init()
    
    var viewModel: SelectKeywordViewModel!
    
    public override init(frame: CGRect) {
        let memberRepository = DummyMemberRepository()
        let updateKeywordUsecase = DefaultUpdateKeywordUseCase(repository: memberRepository)
        
        let keywordRepository = DummyKeywordRepositoryImpl()
        let fetchKeywordUseCase = DefaultFetchKeywordsUseCase(repository: keywordRepository)
        viewModel = SelectKeywordViewModel(fetchKeywordsUseCase: fetchKeywordUseCase, updateKeywordUseCase: updateKeywordUsecase)
        
        super.init(frame: frame)
        
        prepareUI()
    }
    
    required public init?(coder: NSCoder) {
        // TODO: DefaultMemberRepository로 수정해야public 한다.
        let memberRepository = DummyMemberRepository()
        let updateKeywordUsecase = DefaultUpdateKeywordUseCase(repository: memberRepository)
        
        let keywordRepository = DummyKeywordRepositoryImpl()
        let fetchKeywordUseCase = DefaultFetchKeywordsUseCase(repository: keywordRepository)
        viewModel = SelectKeywordViewModel(fetchKeywordsUseCase: fetchKeywordUseCase, updateKeywordUseCase: updateKeywordUsecase)
        
        super.init(coder: coder)
        
        prepareUI()
    }
    
    private func prepareUI() {
        let nibs = Bundle(for: SelectKeywordView.self).loadNibNamed("SelectKeywordView", owner: self, options: nil)
        
        let view = nibs?.first as! UIView
        self.addSubview(view)
        
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        
        initKeywordDataSource()
        keywordCollectionView.dataSource = keywordDataSource
        keywordCollectionView.delegate = self
        initSelectedKeywordsDataSource()
        selectedCollectionView.dataSource = selectedKeywordDataSource
        selectedCollectionView.delegate = self
        viewModel.fetchKeywords()
        self.bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.keywordsSubject
            .map({ $0 ?? [] })
            .sink(receiveCompletion: { completion in
                print("completion: \(completion)")
            }, receiveValue: { keywords in
                self.updateKeywords(with: keywords)
                zip(keywords, KeywordColorFactory.create(keywords: keywords))
                    .map { keyword, color in
                        self.keywordColors[keyword] = color
                    }
                
            }).store(in: &cancellableSet)
        
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
        selectedKeywordDataSource.apply(snapShot)
    }
}

extension SelectKeywordView {
    private func initKeywordDataSource() {
        let keywordNib = UINib(nibName: KeywordCell.nibName, bundle: .init(for: KeywordCell.self))
        let cellRegistration = UICollectionView.CellRegistration<KeywordCell, Keyword>(cellNib: keywordNib) { cell, indexPath, keyword in
            cell.setKeyword(with: keyword)
            
            if let keywordColor = self.keywordColors[keyword] {
                cell.setBackgroundColor(keywordColor)
            }
        }
        
        keywordDataSource = .init(collectionView: keywordCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let index = indexPath.item
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
    }
    
    private func initSelectedKeywordsDataSource() {
        let keywordNib = UINib(nibName: KeywordCell.nibName, bundle: .init(for: KeywordCell.self))
        let cellRegistration = UICollectionView.CellRegistration<KeywordCell, Keyword>(cellNib: keywordNib) { cell, indexPath, keyword in
            cell.setKeyword(with: keyword)
            
            if let keywordColor = self.keywordColors[keyword] {
                cell.setBackgroundColor(keywordColor)
            }
        }
        
        selectedKeywordDataSource = .init(collectionView: selectedCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let index = indexPath.item
            let keyword = self.viewModel.keywords?[index]
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: keyword!)
        })
    }
}

// MARK: UICollectionViewDelegate
extension SelectKeywordView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.toggle(keywordIndex: indexPath.item)
    }
}

extension SelectKeywordView: UICollectionViewDelegateFlowLayout {
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

// MARK: factory method
extension SelectKeywordView {
    //    static public func create() -> SelectKeywordView {
    //
    //
    //    }
}
