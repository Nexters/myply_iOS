//
//  ServiceVersionCell.swift
//  MyPage
//
//  Created by nylah.j on 2022/08/17.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit

class ServiceVersionCell: UICollectionViewCell {

    @IBOutlet var appVersionTitleLabel: UILabel!
    @IBOutlet var appVersionContentTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setVersionNumber(_ version: CGFloat) {
        appVersionContentTitle.text = "\(version)"
    }
}
