//
//  MyPageSectionHeader.swift
//  MyPage
//
//  Created by nylah.j on 2022/08/24.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit

class MyPageSectionHeader: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setTitle(_ text: String) {
        titleLabel.text = text
    }
}
