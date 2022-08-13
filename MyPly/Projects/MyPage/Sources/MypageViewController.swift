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

// MARK: - typealias
typealias KeywordDataSource = UICollectionViewDiffableDataSource<Int, String>
typealias KeywordSnapShot = NSDiffableDataSourceSnapshot<Int, String>

enum MyPageSection: Int {
    case preference = 0
    case serviceMetadata = 1
    case customerService = 2
}

open class MyPageViewController: UIViewController {
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
    
    let writeButton: UIButton = {
        
        MyPageImages
        let image = UIImage(asset: MyPage.MyPageAsset.)
        $0.imageView = .init(image: <#T##UIImage?#>)
        return $0
    }(UIButton())
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        view.addSubview(titleLabel)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(preferenceLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
        preferenceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(33)
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

