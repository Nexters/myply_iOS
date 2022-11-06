//
//  MyPageViewController.swift
//  Home
//
//  Created by 최동규 on 2022/07/29.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit
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
    case serviceMetadata = 0
    case customerService = 1
}

open class MyPageViewController: UIViewController {
    enum Section: Int {
        case serviceInfo = 0
        case customerService = 1
    }
    
    // TODO: repository 교체
    let repository = DummyKeywordRepositoryImpl()
    lazy var fetchKeywordUseCase = DefaultFetchKeywordsUseCase(repository: repository)
    lazy var viewModel = MyPageViewModel(fetchKeywordsUseCase: fetchKeywordUseCase)
    
    private var cancellableBag: Set<AnyCancellable> = .init()
    
    private lazy var collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: compositionalLayout)
    
    private var collectionViewHeight: NSLayoutConstraint?
    
    
    private var dataSource: MyPageDataSource!
    
    let titleLabel: UILabel = {
        $0.text = "마이페이지"
        return $0
    }(UILabel())
    
    
    let writeButton: UIButton = {
        $0.setImage(MyPageAsset.edit.image, for: .normal)
        return $0
    }(UIButton())
    
    private lazy var keywordCollectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: keywordCollectionViewLayout)
    let keywordCollectionViewLayout: UICollectionViewFlowLayout = .init()
    var keywordCollectionViewHeight: NSLayoutConstraint?
    var keywordDataSource: KeywordDataSource!
    var keywordColors: [UIColor]? = nil
    
    
    let firstDividerLine: UIView = {
        $0.backgroundColor = CommonUIAsset.gray80.color
        return $0
    }(UIView())
    
    private var scrollView: UIScrollView!
    private var scrollContentView: UIView!
    
    private var keywordTitleLabel: UILabel = {
        $0.text = "취향키워드"
        return $0
    }(UILabel())
    
    private var editKeywordButton: UIButton = {
        $0.setImage(MyPageAsset.edit.image, for: .normal)
        return $0
    }(UIButton())
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellWithButtonNib = UINib(nibName: MyPageCellWithButton.nibName, bundle: .init(for: MyPageCellWithButton.self))
        collectionView.register(cellWithButtonNib, forCellWithReuseIdentifier: MyPageCellWithButton.identifier)
        
        let cellWithLabelNib = UINib(nibName: MyPageCellWithLabel.nibName, bundle: .init(for: MyPageCellWithLabel.self))
        collectionView.register(cellWithLabelNib, forCellWithReuseIdentifier: MyPageCellWithLabel.identifier)
        
        scrollView = .init(frame: .zero)
        scrollContentView = .init(frame: .zero)
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        scrollContentView.addSubview(keywordCollectionView)
        scrollContentView.addSubview(collectionView)
        scrollContentView.addSubview(firstDividerLine)
        scrollContentView.addSubview(keywordTitleLabel)
        scrollContentView.addSubview(editKeywordButton)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo((tabBarController?.tabBar.frame.origin.y ?? .zero) -  (titleLabel.frame.origin.y + titleLabel.frame.size.height))
        }
        
        scrollContentView.snp.makeConstraints { make in
            make.leading.equalTo(scrollView.contentLayoutGuide.snp.leading)
            make.trailing.equalTo(scrollView.contentLayoutGuide.snp.trailing)
            make.top.equalTo(scrollView.contentLayoutGuide.snp.top)
            make.bottom.equalTo(scrollView.contentLayoutGuide.snp.bottom)
            make.width.equalTo(scrollView.frameLayoutGuide.snp.width)
            make.height.greaterThanOrEqualToSuperview()
        }
        
        keywordTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(scrollContentView.snp.top).offset(30)
            make.leading.equalToSuperview().offset(20)
        }
        
        editKeywordButton.snp.makeConstraints { make in
            make.leading.equalTo(keywordTitleLabel.snp.trailing).offset(11)
            make.centerY.equalTo(keywordTitleLabel.snp.centerY)
        }
        editKeywordButton.addTarget(self, action: #selector(onEditKeywordTouched), for: .touchUpInside)
        keywordCollectionView.snp.makeConstraints { make in
            make.top.equalTo(keywordTitleLabel.snp.bottom).offset(16)
            make.width.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
        }
        
        keywordCollectionView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        firstDividerLine.snp.makeConstraints { make in
            make.top.equalTo(keywordCollectionView.snp.bottom).offset(40)
            make.width.equalToSuperview()
            make.height.equalTo(1)
            make.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(firstDividerLine.snp.bottom)
            make.bottom.equalTo(scrollContentView.snp.bottom)
            make.width.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
        }
        
        initDataSource()
        collectionView.dataSource = dataSource
        collectionView.isScrollEnabled = false
        
        
        var snapShot = MyPageSnapShot()
        snapShot.appendSections(MyPageSection.allCases.map { $0.rawValue })
        snapShot.appendItems(ServiceInfoItems.value.map({ $0.title }), toSection: MyPageSection.serviceMetadata.rawValue)
        snapShot.appendItems(CustomerServiceItems.value.map({ $0.title }), toSection: MyPageSection.customerService.rawValue)
        dataSource.apply(snapShot)
        
        
        initKeywordCollectionView()
        initKeywordDataSource()
        keywordCollectionView.dataSource = keywordDataSource
    }
    
    private func initKeywordCollectionView() {
        keywordCollectionView.delegate = self
        keywordCollectionView.isScrollEnabled = false
        keywordCollectionView.backgroundColor = .clear
        
        let nibName = UINib(nibName: "KeywordCell", bundle: .init(for: KeywordCell.self))
        keywordCollectionView.register(nibName, forCellWithReuseIdentifier: KeywordCell.Constants.reuseIdentifier)
    }
    
    private func initKeywordDataSource() {
        let keywordCellNib = UINib(nibName: KeywordCell.nibName, bundle: .init(for: KeywordCell.self))
        let keywordCellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, String>(cellNib: keywordCellNib) { cell, indexPath, item in
            guard let keywordCell = cell as? KeywordCell else { return }
            let index = indexPath.item
            guard let keyword = self.viewModel.keywords?[index] else { return }
            guard let backgroundColor = self.keywordColors?[index] else { return }
            
            keywordCell.setKeyword(with: keyword)
            keywordCell.setBackgroundColor(backgroundColor)
        }
        
        
        keywordDataSource = .init(collectionView: keywordCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: keywordCellRegistration, for: indexPath, item: itemIdentifier)
        })
    }
    
    // MARK: DataSource
    private func initDataSource() {
        dataSource = .init(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let section = MyPageSection(rawValue: indexPath.section)!
            switch section {
            case .serviceMetadata:
                let item = ServiceInfoItems.value[indexPath.row]
                switch item.content {
                case .image:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPageCellWithButton.identifier, for: indexPath) as! MyPageCellWithButton
                    cell.setTitle(item.title)
                    let underlineVisible = ServiceInfoItems.isLast(item: item) == false
                    cell.makeUnderLine(visible: underlineVisible)
                    return cell
                    
                case .value(let value):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPageCellWithLabel.identifier, for: indexPath) as! MyPageCellWithLabel
                    cell.setVersionNumber(CGFloat(Float(value)!))
                    let underlineVisible = ServiceInfoItems.isLast(item: item) == false
                    cell.makeUnderLine(visible: underlineVisible)
                    return cell
                }
                
            case .customerService:
                let item = CustomerServiceItems.value[indexPath.row]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPageCellWithButton.identifier, for: indexPath) as! MyPageCellWithButton
                cell.setTitle(item.title)
                let underlineVisible = CustomerServiceItems.isLast(item: item) == false
                cell.makeUnderLine(visible: underlineVisible)
                return cell
            }
        })
        
        //         TODO: supplementaryViewProvider 구현하기
        let myPageSectionHeaderNib = UINib(nibName: MyPageSectionHeader.nibName, bundle: .init(for: MyPageSectionHeader.self))
        let myPageSectionHeader = UICollectionView.SupplementaryRegistration(supplementaryNib: myPageSectionHeaderNib, elementKind: MyPageSectionHeader.identifier) { supplementaryView, elementKind, indexPath in
            
            guard let myPageSectionHeader = supplementaryView as? MyPageSectionHeader else {
                return
            }
            
            switch MyPageSection(rawValue: indexPath.row)! {
            case .serviceMetadata:
                myPageSectionHeader.setTitle(ServiceInfoItems.header)
            case .customerService:
                myPageSectionHeader.setTitle(CustomerServiceItems.header)
            }
        }
        
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            return collectionView.dequeueConfiguredReusableSupplementary(using: myPageSectionHeader, for: indexPath)
        }
    }
    
    private func bindViewModel() {
        viewModel.keywordsSubject
            .map({ keywords in
                keywords ?? []
            })
            .sink { keywords in
                self.keywordColors = KeywordColorFactory.create(keywords: keywords)
                self.refreshKeywordCollectionView(with: keywords)
            }.store(in: &cancellableBag)
    }
    
    private func refreshKeywordCollectionView(with keywords: [Keyword]) {
        var snapShot = KeywordSnapShot()
        snapShot.appendSections([0])
        snapShot.appendItems(keywords.map({ $0.value }), toSection: 0)
        keywordDataSource.apply(snapShot, animatingDifferences: false, completion: nil)
    }
}

// MARK: - FactoryMethod
extension MyPageViewController {
    static public func create() -> UIViewController {
        let navigationController = UINavigationController(rootViewController: MyPageViewController())
        return navigationController
    }
}

// MARK: - View
extension MyPageViewController {
    @objc private func onEditKeywordTouched() {
        let editKeywordViewController = MyPageEditKeywordViewController()
        self.navigationController?.pushViewController(editKeywordViewController, animated: false)
    }
}

// MARK: - CollectionView
extension MyPageViewController {
    private var config: UICollectionViewCompositionalLayoutConfiguration {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        return config
    }
    
    private var compositionalLayout: UICollectionViewCompositionalLayout {
        return .init(sectionProvider: { sectionIndex, layoutEnvironment-> NSCollectionLayoutSection? in
            switch Section(rawValue: sectionIndex) {
            case .serviceInfo, .customerService, .none:
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(32 + 22))
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
        }, configuration: config)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MyPageViewController: UICollectionViewDelegateFlowLayout {
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

// MARK: - UICollectionViewDelegate
extension MyPageViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if keywordCollectionView == collectionView {
            sizeToKeywordCollectionViewFit()
        }
        if self.collectionView == collectionView {
            sizeToCollectionViewFit()
        }
    }
    
    private func sizeToKeywordCollectionViewFit() {
        let contentHeight = keywordCollectionView.collectionViewLayout.collectionViewContentSize.height
        if contentHeight == .zero || keywordCollectionViewHeight?.constant == contentHeight { return }
        keywordCollectionViewHeight = keywordCollectionView.heightAnchor.constraint(equalToConstant: contentHeight)
        keywordCollectionViewHeight?.isActive = true
        keywordCollectionView.layoutIfNeeded()
    }
    
    private  func sizeToCollectionViewFit() {
        let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
        if contentHeight == .zero || collectionViewHeight?.constant == contentHeight { return }
        collectionViewHeight = collectionView.heightAnchor.constraint(equalToConstant: contentHeight)
        collectionViewHeight?.isActive = true
        collectionView.layoutIfNeeded()
    }
}
