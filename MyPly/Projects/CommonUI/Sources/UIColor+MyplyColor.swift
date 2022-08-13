//
//  UIColor+MyplyColor.swift
//  CommonUI
//
//  Created by 최동규 on 2022/07/29.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit

extension UIFont {
    static let H1Semibold = UIFont(name: "Pretendard", size: 24)
}


public extension UIColor {

    static let textColor = UIColor.darkGray
    class var begie: UIColor? { return .init(named: "begie") }
    class var gray50: UIColor? { return .init(named: "gray50") }
    class var gray60: UIColor? { return .init(named: "gray60") }
    class var gray70: UIColor? { return .init(named: "gray70") }
    class var gray80: UIColor? { return .init(named: "gray80") }
    class var gray90: UIColor? { return .init(named: "gray90") }

    class var greenLight: UIColor? { return .init(named: "greenLight") }
    class var yellow: UIColor? { return .init(named: "yellow") }
    class var red: UIColor? { return .init(named: "red") }
    class var blue: UIColor? { return .init(named: "blue") }
}


extension UIImage {
    class var search: UIImage? { return .init(named: "search")}
}
