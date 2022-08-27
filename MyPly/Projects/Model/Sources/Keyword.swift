//
//  Keyword.swift
//  SearchDemoApp
//
//  Created by nylah.j on 2022/08/01.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Foundation

public typealias Keywords = [Keyword]

public struct Keyword {
    public let value: String

    public init(_ value: String) {
        self.value = value
    }
}

public struct KeywordText {
    static let keywordFormat = "#%@"

    public let value: String

    public init(keyword: Keyword) {
        value = String(format: Self.keywordFormat, keyword.value)
    }
}
