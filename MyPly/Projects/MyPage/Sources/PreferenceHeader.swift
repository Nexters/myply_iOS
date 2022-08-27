//
//  PreferenceHeader.swift
//  MyPage
//
//  Created by nylah.j on 2022/08/24.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit

class PreferenceHeader: UICollectionReusableView {
    private static let titleConstant = "%@의 취향 키워드"

    
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUserName(name: String) {
        let titleText = String(format: Self.titleConstant, name)
        titleLabel.text = titleText
    }
}
