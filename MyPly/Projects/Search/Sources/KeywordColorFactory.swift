//
//  KeywordColorFactory.swift
//  SearchDemoApp
//
//  Created by nylah.j on 2022/08/01.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Foundation
import UIKit

struct KeywordColorFactory {
    static let colors: [UIColor] = [
        .blue,
        .yellow,
        .red,
        .greenLight
        
    ].compactMap { $0 }
    
    private static var colorCount: Int {
        colors.count
    }
    
    static func create(keywords: [Keyword]) -> [UIColor] {
        keywords.enumerated()
            .map { (index, keyword) in
                let colorIndex = index % colorCount
                return colors[colorIndex]
            }
    }
}
