//
//  SearchViewModel.swift
//  SearchDemoApp
//
//  Created by nylah.j on 2022/08/01.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Combine

//typealias Publisher<Output> = Published<Output>.Publisher
typealias Keywords = [Keyword]


protocol SearchViewModelOuput {
    var keywordsPublisher: AnyPublisher<Keywords?, Never> { get }
    var keywords: Keywords? { get }
}

protocol SearchViewModelInput {
    func fetchKeyword() async throws
}

protocol SearchViewModel: SearchViewModelOuput & SearchViewModelInput {}

class DefaultSearchViewModel: SearchViewModel, ObservableObject {
    
    var keywordsSubject: CurrentValueSubject<Keywords?, Never> = .init(nil)
    var keywordsPublisher: AnyPublisher<Keywords?, Never> {
        keywordsSubject.eraseToAnyPublisher()
    }
    var keywords: Keywords? {
        keywordsSubject.value
    }
    
    private let fetchKeywordUseCase: FetchKeywordsUseCase
    
    init(fetchKeywordUseCase: FetchKeywordsUseCase) {
        self.fetchKeywordUseCase = fetchKeywordUseCase
    }
    
    // MARK: - input
    func fetchKeyword() async throws {
        let keywords = try await fetchKeywordUseCase.execute()
        keywordsSubject.value = keywords
    }
}
