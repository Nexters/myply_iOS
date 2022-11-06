//
//  MemoUsecase.swift
//  Model
//
//  Created by 최동규 on 2022/10/09.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Foundation
import Moya
import MyPlyAPI
import Combine

public struct MemoUsecase {

    let provider = MoyaProvider<MyPlyTarget>()

    public init() {
        
    }

    public func unMemoPlaylist(youtubeVideoID: String) -> AnyPublisher<Bool, Error> {
        return Future({ promise in

            provider.request(.unMemo(youtubeVideoID: youtubeVideoID)) { result in
                switch result {
                case .success(let response):
                    do {
                        if (200...220).contains(response.statusCode) {
                            promise(.success((true)))
                        }
                        promise(.success((false)))
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

    public func memoPlaylist(youtubeVideoID: String, body: String?) -> AnyPublisher<Bool, Error> {
        return Future({ promise in

            provider.request(.memo(youtubeVideoID: youtubeVideoID, body: body)) { result in
                switch result {
                case .success(let response):
                    do {
                        if (200...220).contains(response.statusCode) {
                            promise(.success((true)))
                        }
                        promise(.success((false)))
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
