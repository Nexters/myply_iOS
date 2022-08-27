//
//  HomeUsecase.swift
//  Home
//
//  Created by 최동규 on 2022/08/27.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Foundation
import Combine
import CommonUI
import Moya
import MyPlyAPI
import Model

protocol PlaylistUsecase {
    func loadPlaylist(nextToken: String?) -> AnyPublisher<([HomePlaylistPresentable], String?), Error>
}

extension Playlist: HomePlaylistPresentable {


}

struct RecentlyPlaylistUsecase: PlaylistUsecase {

    let provider = MoyaProvider<MyPlyTarget>()

    func loadPlaylist(nextToken: String?) -> AnyPublisher<([HomePlaylistPresentable], String?), Error> {
        return Future({ promise in
            provider.request(.musics(nextToken: nextToken, order: "recent")) { result in
                switch result {
                case .success(let response):
                    do {
                        let decoder = JSONDecoder()
                        let playlists = try decoder.decode([Playlist].self, from: response.data, keyPath: "data.musics")
                        let nextPageToken = try? decoder.decode(String?.self, from: response.data, keyPath: "data.nextPageToken")
                        promise(.success((playlists, nextPageToken)))

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

struct PopularPlaylistUsecase: PlaylistUsecase {

    let provider = MoyaProvider<MyPlyTarget>()

    func loadPlaylist(nextToken: String?) -> AnyPublisher<([HomePlaylistPresentable], String?), Error> {
        return Future({ promise in
            provider.request(.musics(nextToken: nextToken, order: "count")) { result in
                switch result {
                case .success(let response):
                    do {
                        let decoder = JSONDecoder()
                        let playlists = try decoder.decode([Playlist].self, from: response.data, keyPath: "data.musics")
                        let nextPageToken = try? decoder.decode(String?.self, from: response.data, keyPath: "data.nextPageToken")
                        promise(.success((playlists, nextPageToken)))

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

struct FavoritePlaylistUsecase: PlaylistUsecase {

    let provider = MoyaProvider<MyPlyTarget>()

    func loadPlaylist(nextToken: String?) -> AnyPublisher<([HomePlaylistPresentable], String?), Error>{
        return Future({ promise in
            provider.request(.preferredMusics(nextToken: nextToken)) { result in
                switch result {
                case .success(let response):
                    do {
                        let decoder = JSONDecoder()
                        let playlists = try decoder.decode([Playlist].self, from: response.data, keyPath: "data.musics")
                        let nextPageToken = try? decoder.decode(String?.self, from: response.data, keyPath: "data.nextPageToken")
                        promise(.success((playlists, nextPageToken)))

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
