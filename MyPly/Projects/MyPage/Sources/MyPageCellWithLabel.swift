//
//  MyPageCellWithLabel.swift
//  MyPage
//
//  Created by nylah.j on 2022/08/17.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit

class MyPageCellWithLabel: UICollectionViewCell {

    @IBOutlet var appVersionTitleLabel: UILabel!
    @IBOutlet var appVersionContentTitle: UILabel!
    @IBOutlet weak var underline: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setVersionNumber(_ version: CGFloat) {
        appVersionContentTitle.text = "\(version)"
    }
    
    func makeUnderLine(visible: Bool) {
        underline.isHidden = !visible
    }
}
