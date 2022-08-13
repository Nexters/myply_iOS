//
//  LeftAlignedCollectionViewFlowLayout.swift
//  Search
//
//  Created by nylah.j on 2022/07/30.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing - 5
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        return attributes
    }
}
