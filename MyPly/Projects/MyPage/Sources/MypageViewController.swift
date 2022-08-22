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
    enum Constant {
        static let preferenceHeaderElementKind = "preferenceHeaderElementKind"
    }
    enum Section: Int {
        case preference = 0
        case serviceInfo = 1
        case customerService = 2
    }
    lazy var collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: collectionViewLayout)
    let sectionProvider =  { (sectionIndex: Int,
                              layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
        switch Section(rawValue: sectionIndex) {
        case .preference:
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(28), heightDimension: .absolute(14))
            let headerAnchor = NSCollectionLayoutAnchor(edges: [.top])
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(32))
            let supplementaryItem = NSCollectionLayoutSupplementaryItem(layoutSize: headerSize, elementKind: Constant.preferenceHeaderElementKind, containerAnchor: headerAnchor)
            let item = NSCollectionLayoutItem(layoutSize: itemSize  , supplementaryItems: [supplementaryItem])
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(18))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            //        let group = NSCollectionLayoutGroup(layoutSize: groupSize)
            let section = NSCollectionLayoutSection(group: group)
            return section
            
        case .serviceInfo, .customerService, .none:
            let headerAnchor = NSCollectionLayoutAnchor(edges: [.top])
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(48))
            let supplementaryItem = NSCollectionLayoutSupplementaryItem(layoutSize: headerSize, elementKind: Constant.preferenceHeaderElementKind, containerAnchor: headerAnchor)
            
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(48))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize , supplementaryItems: [supplementaryItem])
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(206))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
    
    let config: UICollectionViewCompositionalLayoutConfiguration = {
        $0.interSectionSpacing = 20
        return $0
    }(UICollectionViewCompositionalLayoutConfiguration())
    
    
    private lazy var collectionViewLayout: UICollectionViewCompositionalLayout = .init(sectionProvider: sectionProvider, configuration: config)
    
    private var dataSource: MyPageDataSource!
    
    let scrollView: UIScrollView = .init()
    let contentView: UIView = .init()
    
    let titleLabel: UILabel = {
        $0.text = "마이페이지"
        return $0
    }(UILabel())
    
    let preferenceLabel: UILabel = {
        $0.text = "%@의 취향키워드"
        return $0
    }(UILabel())
    
    let serviceInfoLabel: UILabel = {
        $0.text = "서비스 정보"
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
        
        collectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        let serviceInfoCellNib = UINib(nibName: "ServiceInfoCell", bundle: .init(for: ServiceInfoCell.self))
        collectionView.register(serviceInfoCellNib, forCellWithReuseIdentifier: ServiceInfoCell.identifier)
        
        let serviceVersionCellNib = UINib(nibName: "ServiceVersionCell", bundle: .init(for: ServiceInfoCell.self))
        collectionView.register(serviceVersionCellNib, forCellWithReuseIdentifier: ServiceVersionCell.identifier)
        
        view.addSubview(scrollView)
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(preferenceLabel)
        contentView.addSubview(writeButton)
        contentView.addSubview(keywordCollectionView)
        contentView.addSubview(serviceInfoLabel)
        contentView.addSubview(firstDividerLine)
        contentView.addSubview(appVersionInfoView)
        
        collectionView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.leading.top.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.leading.top.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        contentView.snp.makeConstraints { make in
            make.leading.equalTo(scrollView.contentLayoutGuide.snp.leading)
            make.top.equalTo(titleLabel.snp.bottom)
            make.width.equalToSuperview()
        }
        
        preferenceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(33)
        }
        
        writeButton.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.width.equalTo(18)
            make.leading.equalTo(preferenceLabel.snp.leading).offset(11)
            make.centerY.equalTo(preferenceLabel.snp.centerY)
        }
        
        keywordCollectionView.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-40)
            make.leading.equalTo(preferenceLabel)
        }
        
        firstDividerLine.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(1)
            make.leading.equalToSuperview()
            make.top.equalTo(keywordCollectionView.snp.bottom).offset(40)
        }
        
        serviceInfoLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(firstDividerLine.snp.bottom).offset(32)
        }
        
        appVersionInfoView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.leading.equalToSuperview()
            make.top.equalTo(serviceInfoLabel.snp.bottom).offset(8)
        }
        
        initDataSource()
    }
    
    private func initDataSource() {
        dataSource = .init(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let section = MyPageSection(rawValue: indexPath.row)!
            switch section {
//            case .preference:
//                // TODO: cell identifier 수정하기
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeywordCell.identifier, for: indexPath)
//                return cell
//            case .serviceMetadata:
//                return collectionView.dequeueReusableCell(withReuseIdentifier: ServiceInfoCell.identifier, for: indexPath)
//            case .customerService:
//                // TODO: cell identifier 수정하기
//                return collectionView.dequeueReusableCell(withReuseIdentifier: "customerService", for: indexPath)
            default:
                let item = ServiceInfoItems.value[indexPath.item]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ServiceInfoCell.identifier, for: indexPath) as! ServiceInfoCell
                cell.setTitle(item.title)
                return cell
            }
        })
        
        collectionView.dataSource = dataSource
        
        // TODO: supplementaryViewProvider 구현하기
        //        dataSource.supplementaryViewProvider = { (view, kind, indexPath)
        //
        //        }
        
        var snapShot = MyPageSnapShot()
        snapShot.appendSections(MyPageSection.allCases.map { $0.rawValue })
        snapShot.appendItems([], toSection: MyPageSection.preference.rawValue)
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


