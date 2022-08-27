//
//  MyPageCellWithLabel.swift
//  MyPage
//
//  Created by nylah.j on 2022/08/20.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit

class MyPageCellWithButton: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var underline: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setTitle(_ text: String) {
        titleLabel.text = text
    }
    
    func makeUnderLine(visible: Bool) {
        underline.isHidden = !visible
    }
}
