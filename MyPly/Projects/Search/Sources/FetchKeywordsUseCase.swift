//
//  File.swift
//  Search
//
//  Created by nylah.j on 2022/08/03.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Foundation

protocol FetchKeywordsUseCase {
    func execute() async throws -> Keywords
}

final class DefaultFetchKeywordsUseCase : FetchKeywordsUseCase {
    private let repository: KeywordRepository
    
    init(repository: KeywordRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> Keywords {
        return try await repository.getKeywords()
    }
}
