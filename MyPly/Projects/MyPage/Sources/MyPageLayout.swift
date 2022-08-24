////
////  MyPageLayout.swift
////  MyPage
////
////  Created by nylah.j on 2022/08/24.
////  Copyright © 2022 cocaine.io. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class MyPageLayout: UICollectionViewCompositionalLayout {
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        let attributes = super.layoutAttributesForItem(at: indexPath)
//
//
//        let section = MyPageSection(rawValue: indexPath.section)!
//        switch section {
//        case .preference:
//            var leftMargin: CGFloat = 0.0
//            var maxY: CGFloat = -1.0
//            if attributes!.frame.origin.y >= maxY {
//                leftMargin = 0
//            }
//            attributes!.frame.origin.x = leftMargin
//            leftMargin += attributes.frame.width + minimumInteritemSpacing - 5
//            maxY = max(attributes.frame.maxY, maxY)
//        
//            
//            return attributes
//        case .serviceMetadata:
//            return attributes
//        case .customerService:
//            return attributes
//        }
//    }
//
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//
//    }
//}
