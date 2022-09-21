//
//  SelectKeywordViewModel.swift
//  CommonUI
//
//  Created by nylah.j on 2022/08/27.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Combine
import Model

class SelectKeywordViewModel {
    var keywordsSubject: CurrentValueSubject<Keywords?, Error> = .init(nil)
    var keywords: Keywords? { keywordsSubject.value }

    var selectedKeywordsSubject: CurrentValueSubject<Keywords?, Error> = .init([])
    
    var isEmptySelected: AnyPublisher<Bool, Never> {
        selectedKeywordsSubject
            .replaceError(with: nil)
            .map { $0?.isEmpty == true }
            .eraseToAnyPublisher()
    }
    
    var selectedKeywords: Keywords? {
        selectedKeywordsSubject.value
    }
    let fetchKeywordsUseCase: FetchKeywordsUseCase
    let updateKeywordUseCase: UpdateKeywordUsecase
    
    init(fetchKeywordsUseCase: FetchKeywordsUseCase, updateKeywordUseCase: UpdateKeywordUsecase) {
        self.fetchKeywordsUseCase = fetchKeywordsUseCase
        self.updateKeywordUseCase = updateKeywordUseCase
    }
    
    func toggle(keywordIndex: Int) {
        guard let keyword = keywords?[keywordIndex] else {
            return
        }
        
        if selectedKeywords?.contains(keyword) == true {
            deselect(keyword: keyword)
            return
        }
        
        select(keyword: keyword)
    }
    
    func fetchKeywords() {
        Task {
            let keywords = try? await fetchKeywordsUseCase.execute()
            keywordsSubject.value = keywords
        }
    }
    
    private func select(keyword: Keyword) {
        var keywords = selectedKeywordsSubject.value
        keywords?.append(keyword)
        selectedKeywordsSubject.send(keywords)
    }
    
    
    private func deselect(keyword: Keyword) {
        let index = selectedKeywordsSubject.value?.enumerated()
            .filter({ (_, originKeyword) in
                originKeyword.value == keyword.value
            })
            .map { (index, _) in index }
            .first
        
        guard let index = index else { return }
        
        var keywords = selectedKeywordsSubject.value
        keywords?.remove(at: index)
        
        selectedKeywordsSubject.send(keywords)
    }
}
