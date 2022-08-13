//
//  UIFont.swift
//  Search
//
//  Created by nylah.j on 2022/07/30.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Foundation
import UIKit
import Search

extension UIFont {
    static let H1Semibold = UIFont(name: "Pretendard", size: 24)
}

extension UIColor {
    class var begie: UIColor? { return SearchAsset.Asset.begie.color }
    class var gray50: UIColor? { return SearchAsset.Asset.gray50.color }
    class var gray70: UIColor? { return SearchAsset.Asset.gray70.color }
    class var gray80: UIColor? { return SearchAsset.Asset.gray80.color }
    class var gray90: UIColor? { return SearchAsset.Asset.gray90.color }
    
    class var greenLight: UIColor? { return SearchAsset.Asset.greenLight.color }
    class var yellow: UIColor? { return SearchAsset.Asset.yellow.color }
    class var red: UIColor? { return SearchAsset.Asset.red.color }
    class var blue: UIColor? { return SearchAsset.Asset.blue.color }
}

extension UIImage {
    class var search: UIImage? { return SearchAsset.Image.search.image }
}
