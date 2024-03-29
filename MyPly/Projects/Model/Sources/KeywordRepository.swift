//
//  KeywordRepository.swift
//  SearchDemoApp
//
//  Created by nylah.j on 2022/08/01.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Foundation

enum KeywordResponse {
    case success(keywords: [Keyword])
}

public protocol KeywordRepository {
    func getKeywords() async throws -> Keywords
}

public struct DummyKeywordRepositoryImpl: KeywordRepository {
    public init() {}
    
    public func getKeywords() async throws -> Keywords {
        let keywords: [Keyword] = .init([
            .init("케이팝"),
            .init("청량"),
            .init("데이식스"),
            .init("수록곡"),
            .init("여름밤"),
            .init("감성"),
            .init("하이틴"),
            .init("힙합")
        ])
        return keywords
    }
}
