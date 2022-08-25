//
//  KeywordColorFactory.swift
//  SearchDemoApp
//
//  Created by nylah.j on 2022/08/01.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Foundation
import UIKit
import Model

public struct KeywordColorFactory {
    private static let colors: [UIColor] = [
        CommonUIAsset.blue.color,
        CommonUIAsset.yellow.color,
        CommonUIAsset.red.color,
        CommonUIAsset.greenLight.color
        
    ].compactMap { $0 }
    
    private static var colorCount: Int {
        colors.count
    }
    
    public static func create(keywords: [Keyword]) -> [UIColor] {
        keywords.enumerated()
            .map { (index, keyword) in
                let colorIndex = index % colorCount
                return colors[colorIndex]
            }
    }
}
