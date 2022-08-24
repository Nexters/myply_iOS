//
//  MyPageViewModel.swift
//  MyPage
//
//  Created by nylah.j on 2022/08/22.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Combine
import Model

class MyPageViewModel {
    let keywordsSubject = CurrentValueSubject<Keywords?, Never>(nil)
    var keywords: Keywords? {
        keywordsSubject.value
    }
q
    let fetchKeywordsUseCase: FetchKeywordsUseCase
    
    init(fetchKeywordsUseCase: FetchKeywordsUseCase) {
        self.fetchKeywordsUseCase = fetchKeywordsUseCase
    }
    
    func fetchKeywords() {
        Task {
            let keywords = await try? fetchKeywordsUseCase.execute()
            keywordsSubject.send(keywords)
        }
    }
}
