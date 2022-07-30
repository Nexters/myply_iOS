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
        return $0
    }(UITextField())
    
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.begie
        
        view.addSubview(titleLabel)
        view.addSubview(searchField)
        
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
    }
}
