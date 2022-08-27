//
//  MyPageViewController.swift
//  Home
//
//  Created by 최동규 on 2022/07/29.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit
import Library
import Alamofire
import SnapKit
import MyPage
import CommonUI
import Model
import Combine

// MARK: - typealias
typealias KeywordDataSource = UICollectionViewDiffableDataSource<Int, String>
typealias KeywordSnapShot = NSDiffableDataSourceSnapshot<Int, String>
typealias MyPageDataSource = UICollectionViewDiffableDataSource<Int, String>
typealias MyPageSnapShot = NSDiffableDataSourceSnapshot<Int, String>

enum MyPageSection: Int, CaseIterable {
    case preference = 0
    case serviceMetadata = 1
    case customerService = 2
}

open class MyPageViewController: UIViewController {
    enum Section: Int {
        case preference = 0
        case serviceInfo = 1
        case customerService = 2
    }
    
    // TODO: repository 교체
    let repository = DummyKeywordRepositoryImpl()
    lazy var fetchKeywordUseCase = DefaultFetchKeywordsUseCase(repository: repository)
    lazy var viewModel = MyPageViewModel(fetchKeywordsUseCase: fetchKeywordUseCase)
    var keywordColors: [UIColor] = []
    
    private var cancellableBag: Set<AnyCancellable> = .init()
    
    private var collectionView: UICollectionView!
    private lazy var collectionViewLayout: UICollectionViewCompositionalLayout = .init(sectionProvider: sectionProvider, configuration: config)
    
    let config: UICollectionViewCompositionalLayoutConfiguration = {
        $0.interSectionSpacing = 20
        return $0
    }(UICollectionViewCompositionalLayoutConfiguration())
    
    
    let sectionProvider =  { (sectionIndex: Int,
                              layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
        
        switch Section(rawValue: sectionIndex) {
        case .preference:
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(32))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: PreferenceHeader.identifier, alignment: .top)

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(192))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [header]
            return section
            
        case .serviceInfo, .customerService, .none:
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(32))
            let header =
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: MyPageSectionHeader.identifier, alignment: .top)
            
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [header]
            return section
        }
    }
    
    private var dataSource: MyPageDataSource!
    
    let titleLabel: UILabel = {
        $0.text = "마이페이지"
        return $0
    }(UILabel())
    
    lazy var serviceInfoStackView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.addArrangedSubview(appVersionInfoView)
        
        return $0
    }(UIStackView())
    
    let writeButton: UIButton = {
        $0.setImage(MyPageAsset.edit.image, for: .normal)
        return $0
    }(UIButton())
    
    lazy var keywordCollectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: keywordCollectionViewLayout)
    let keywordCollectionViewLayout: UICollectionViewFlowLayout = .init()
    
    let appVersionInfoView: AppVersionInfoView = .init()
    
    let firstDividerLine: UIView = {
        $0.backgroundColor = CommonUIAsset.gray80.color
        return $0
    }(UIView())
    
    let secondDividerLine: UIView = {
        $0.backgroundColor = CommonUIAsset.gray80.color
        return $0
    }(UIView())
    
    let thirdDividerLine: UIView = {
        $0.backgroundColor = CommonUIAsset.gray80.color
        return $0
    }(UIView())
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView = .init(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        let cellWithButtonNib = UINib(nibName: MyPageCellWithButton.nibName, bundle: .init(for: MyPageCellWithButton.self))
        collectionView.register(cellWithButtonNib, forCellWithReuseIdentifier: MyPageCellWithButton.identifier)
        
        let cellWithLabelNib = UINib(nibName: MyPageCellWithLabel.nibName, bundle: .init(for: MyPageCellWithLabel.self))
        collectionView.register(cellWithLabelNib, forCellWithReuseIdentifier: MyPageCellWithLabel.identifier)
        
        
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        initDataSource()
        initKeywordCollectionView()
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
        let keywordListCell = UICollectionView.CellRegistration<KeywordListCell, String> {
            cell, indexPath, itemIdentifier in
            guard let keywords = self.viewModel.keywords else { return }
            
            cell.setKeywords(keywords: keywords)
            cell.sizeToFit()
        }
       
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
    
    // MARK: DataSource
    private func initDataSource() {
        dataSource = .init(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let section = MyPageSection(rawValue: indexPath.section)!
            switch section {
            case .preference:
             
               
            case .serviceMetadata:
                let item = ServiceInfoItems.value[indexPath.row]
                switch item.content {
                case .image:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPageCellWithButton.identifier, for: indexPath) as! MyPageCellWithButton
                    cell.setTitle(item.title)
                    return cell
                    
                case .value(let value):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPageCellWithLabel.identifier, for: indexPath) as! MyPageCellWithLabel
                    cell.setVersionNumber(CGFloat(Float(value)!))
                    return cell
                }
                
            case .customerService:
                let item = CustomerServiceItems.value[indexPath.row]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPageCellWithButton.identifier, for: indexPath) as! MyPageCellWithButton
                cell.setTitle(item.title)
                return cell
            }
        })
        
        collectionView.dataSource = dataSource
        
//         TODO: supplementaryViewProvider 구현하기
        let preferenceHeaderNib = UINib(nibName: PreferenceHeader.nibName, bundle: .init(for: PreferenceHeader.self))
        let preferenceHeader = UICollectionView.SupplementaryRegistration(supplementaryNib: preferenceHeaderNib, elementKind: PreferenceHeader.identifier) { supplementaryView, elementKind, indexPath in
            
            let name = "마이플리"
            guard let preferenceHeader = supplementaryView as? PreferenceHeader else {
                return
            }
            preferenceHeader.setUserName(name: name)
        }
        
        let myPageSectionHeaderNib = UINib(nibName: MyPageSectionHeader.nibName, bundle: .init(for: MyPageSectionHeader.self))
        let myPageSectionHeader = UICollectionView.SupplementaryRegistration(supplementaryNib: myPageSectionHeaderNib, elementKind: MyPageSectionHeader.identifier) { supplementaryView, elementKind, indexPath in
            
            guard let myPageSectionHeader = supplementaryView as? MyPageSectionHeader else {
                return
            }
            
            switch MyPageSection(rawValue: indexPath.row)! {
            case .preference:
                break
            case .serviceMetadata:
                myPageSectionHeader.setTitle(ServiceInfoItems.header)
            case .customerService:
                myPageSectionHeader.setTitle(CustomerServiceItems.header)
            }
        }
        
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            let section = indexPath.section
            switch MyPageSection(rawValue: section)! {
            case .preference:
                return collectionView.dequeueConfiguredReusableSupplementary(using: preferenceHeader, for: indexPath)
            case .serviceMetadata, .customerService:
                return collectionView.dequeueConfiguredReusableSupplementary(using: myPageSectionHeader, for: indexPath)
            }
        }
        
        var snapShot = MyPageSnapShot()
        snapShot.appendSections(MyPageSection.allCases.map { $0.rawValue })
        snapShot.appendItems([], toSection: MyPageSection.preference.rawValue)
        snapShot.appendItems(ServiceInfoItems.value.map({ $0.title }), toSection: MyPageSection.serviceMetadata.rawValue)
        snapShot.appendItems(CustomerServiceItems.value.map({ $0.title }), toSection: MyPageSection.customerService.rawValue)
        dataSource.apply(snapShot)
        
        bindViewModel()
        viewModel.fetchKeywords()
    }
    
    private func bindViewModel() {
        viewModel.keywordsSubject
            .map({ keywords in
                keywords ?? []
            })
            .sink { keywords in
                self.keywordColors = KeywordColorFactory.create(keywords: keywords)
                self.refreshKeywords(keywords: keywords)
            }.store(in: &cancellableBag)
    }
    
    private func refreshKeywords(keywords: Keywords?) {
        var snapShot = MyPageSnapShot()
        snapShot.appendSections(MyPageSection.allCases.map { $0.rawValue })
        snapShot.appendItems([KeywordListCell.identifier], toSection: MyPageSection.preference.rawValue)
        snapShot.appendItems(ServiceInfoItems.value.map({ $0.title }), toSection: MyPageSection.serviceMetadata.rawValue)
        snapShot.appendItems(CustomerServiceItems.value.map({ $0.title }), toSection: MyPageSection.customerService.rawValue)
        dataSource.apply(snapShot)
    }
}



extension MyPageViewController {
    static func create() -> MyPageViewController? {
        let storyBoard = UIStoryboard(name: "MyPage", bundle: .init(for: self))
        return storyBoard.instantiateViewController(withIdentifier: "MyPageViewController") as? MyPageViewController
    }
}
// MARK: View
extension MyPageViewController {
    private func initUI() {
        
    }
}


