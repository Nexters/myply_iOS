//
//  MyPageEditKeywordViewController.swift
//  MyPage
//
//  Created by nylah.j on 2022/08/30.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Foundation
import UIKit
import CommonUI

class MyPageEditKeywordViewController: UIViewController {
    let selectKeywordView: SelectKeywordView = SelectKeywordView(frame: .zero)
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.addSubview(selectKeywordView)
        selectKeywordView.frame = view.bounds
    }
}
