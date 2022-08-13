//
//  SearchViewModel.swift
//  SearchDemoApp
//
//  Created by nylah.j on 2022/08/01.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Combine
import Model

//typealias Publisher<Output> = Published<Output>.Publisher
typealias Keywords = [Keyword]


protocol SearchViewModelOuput {
    var keywordsPublisher: AnyPublisher<Keywords?, Never> { get }
    var keywords: Keywords? { get }
    
    var searchResultPublisher: AnyPublisher<[Playlist]?, Never> { get }
}

protocol SearchViewModelInput {
    func fetchKeyword() async throws
    func search(param: String)
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
    
    var searchResultSubjet: CurrentValueSubject<[Playlist]?, Never> = .init(nil)
    var searchResultPublisher: AnyPublisher<[Playlist]?, Never> {
        searchResultSubjet.eraseToAnyPublisher()
    }
    var searchResults: [Playlist]? {
        searchResultSubjet.value
    }
    
    private let fetchKeywordUseCase: FetchKeywordsUseCase
    private let searchPlaytlistUsecase: SearchPlaylistUseCase
    
    init(fetchKeywordUseCase: FetchKeywordsUseCase, searchPlaylistUseCase: SearchPlaylistUseCase) {
        self.fetchKeywordUseCase = fetchKeywordUseCase
        self.searchPlaytlistUsecase = searchPlaylistUseCase
    }
    
    // MARK: - input
    func fetchKeyword() async throws {
        let keywords = try await fetchKeywordUseCase.execute()
        keywordsSubject.value = keywords
    }
    
    func search(param: String) {
        // TODO: isEmpty 로직 제거하기
        if param.isEmpty {
            searchResultSubjet.value = nil
        }
        else {
            Task {
                let searchResult = try await searchPlaytlistUsecase.execute(param: param)
                searchResultSubjet.value = searchResult
            }
        }
    }
}
