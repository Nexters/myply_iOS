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
        $0.textColor = UIColor.gray50
        $0.backgroundColor = .white
        return $0
    }(UITextField())
    
    private var bestSearchKeywordsTitle: UILabel = {
        $0.text = "마이플리 유저의 인기 검색어"
        $0.textColor = UIColor.gray70
        return $0
    }(UILabel())
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.begie
        
        view.addSubview(titleLabel)
        view.addSubview(searchField)
        view.addSubview(bestSearchKeywordsTitle)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(9)
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
    }
}
