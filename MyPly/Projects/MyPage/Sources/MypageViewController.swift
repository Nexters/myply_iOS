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

enum MyPageSection: Int {
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
    let collectionViewLayout: UICollectionViewCompositionalLayout = .init(sectionProvider: { sectionIndex, environment in
        
        let section: NSCollectionLayoutSection
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
        
    case .serviceInfo:
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(<#T##CGFloat#>), heightDimension: .fractionalHeight(<#T##CGFloat#>))
        
        let item = NSCollectionLayoutItem(layoutSize: <#T##NSCollectionLayoutSize#>, supplementaryItems: <#T##[NSCollectionLayoutSupplementaryItem]#>)
        break
    case .customerService:
        break
    case none:
        break
    }
        
    }, configuration: <#T##UICollectionViewCompositionalLayoutConfiguration#>)
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
        
        keywordCollectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.addSubview(scrollView)
        view.addSubview(titleLabel)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(preferenceLabel)
        contentView.addSubview(writeButton)
        contentView.addSubview(keywordCollectionView)
        contentView.addSubview(serviceInfoLabel)
        contentView.addSubview(firstDividerLine)
        contentView.addSubview(appVersionInfoView)
        
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


