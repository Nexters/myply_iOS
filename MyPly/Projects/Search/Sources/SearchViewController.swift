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
        $0.textColor = UIColor.black
        return $0
    }(UILabel())
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(9)
        }
    }
}
