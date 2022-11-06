//
//  LibraryUsecase.swift
//  Library
//
//  Created by 최모지 on 2022/11/06.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Model

protocol LibraryUsecase {
    func loadLibraryList() -> AnyPublisher<[Memo], Error>
}

struct LibraryMemoUsecase: LibraryUsecase {
    
    let provider = MoyaProvider<MyPlyTarget>()
    
    func loadLibraryList() -> AnyPublisher<[Memo], Error> {
        return Future({ promise in
            provider.request(.getMemoList) { result in
                switch result {
                case .success(let response):
                    do {
                        let decoder = JSONDecoder()
                        let memos = try decoder.decode([Memo].self, from: response.data, keyPath: "data.memos")
                        print("🎉🎉🎉🎉🎉 memos: \(memos)")
                        promise(.success(memos))
                    }
                    catch(let error) {
                        promise(.failure(error))
                    }

                    case .failure(let error):
                    promise(.failure(error))
                }
            }
        }) .eraseToAnyPublisher()
    }
}
