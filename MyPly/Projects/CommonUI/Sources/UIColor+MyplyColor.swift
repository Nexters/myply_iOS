//
//  UIColor+MyplyColor.swift
//  CommonUI
//
//  Created by 최동규 on 2022/07/29.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit

public extension UIFont {
    static let H1Semibold = UIFont(name: "Pretendard", size: 24)
}



public public extension UIColor {
    static let textColor = UIColor.darkGray

    class var begie: UIColor? { return CommonUIAsset.begie.color }
    class var gray50: UIColor? { return CommonUIAsset.gray50.color }
    class var gray70: UIColor? { return CommonUIAsset.gray70.color }
    class var gray80: UIColor? { return CommonUIAsset.gray80.color }
    class var gray90: UIColor? { return CommonUIAsset.gray90.color }
    
    class var greenLight: UIColor? { return CommonUIAsset.greenLight.color }
    class var yellow: UIColor? { return CommonUIAsset.yellow.color }
    class var red: UIColor? { return CommonUIAsset.red.color }
    class var blue: UIColor? { return CommonUIAsset.blue.color }
}


extension UIImage {
    class var search: UIImage? { return .init(named: "search")}
}
