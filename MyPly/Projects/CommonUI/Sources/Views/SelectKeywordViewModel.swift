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

    var selectedKeywordsSubject: CurrentValueSubject<Keywords?, Error> = .init(nil)
    
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
        
        Task {
            let keywords = try await fetchKeywordsUseCase.execute()
            selectedKeywordsSubject.send(keywords)
        }
    }
    
    func toggle(keyword: Keyword) {
        if selectedKeywords?.contains(keyword) == true {
            select(keyword: keyword)
            return
        }
        
        deselect(keyword: keyword)
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
