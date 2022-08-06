//
//  SearchViewModel.swift
//  SearchDemoApp
//
//  Created by nylah.j on 2022/08/01.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Combine

typealias Publisher<Output> = Published<Output>.Publisher
typealias Keywords = [Keyword]


protocol SearchViewModelOuput {
    var keywordsPublisher: Publisher<Keywords?> { get }
    var keywords: Keywords? { get }
}

protocol SearchViewModelInput {
    func fetchKeyword() async throws
}

protocol SearchViewModel: SearchViewModelOuput & SearchViewModelInput {}

class DefaultSearchViewModel: SearchViewModel {
    // MARK: - output
    @Published var keywords: Keywords? = nil
    var keywordsPublisher: Publisher<Keywords?> { $keywords }
    
    private let fetchKeywordUseCase: FetchKeywordsUseCase
    
    init(fetchKeywordUseCase: FetchKeywordsUseCase) {
        self.fetchKeywordUseCase = fetchKeywordUseCase
    }
    
    // MARK: - input
    func fetchKeyword() async throws {
        let keywords = try await fetchKeywordUseCase.execute()
        self.keywords = keywords
    }
}
