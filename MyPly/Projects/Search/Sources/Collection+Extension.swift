//
//  Collection+Extension.swift
//  Search
//
//  Created by nylah.j on 2022/08/12.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
