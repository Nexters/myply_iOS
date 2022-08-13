//
//  TouchPassedCollectionView.swift
//  CommonUI
//
//  Created by 최동규 on 2022/08/06.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit

public class TouchPassedCollectionView: UICollectionView {

    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        delaysContentTouches = false
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        delaysContentTouches = false
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        delaysContentTouches = false
    }
    public override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIButton {
            return true
        }
        return super.touchesShouldCancel(in: view)
    }
}
