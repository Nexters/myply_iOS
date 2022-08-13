//
//  HomeViewModel.swift
//  Home
//
//  Created by 최동규 on 2022/08/06.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Foundation
import Combine
import CommonUI

struct MockHomePlaylist: HomePlaylistPresentable {
    var title: String
    var isMemoed: Bool
    var youtubeTags: [String]
}

protocol HomeMenu {

    var title: String { get }
    var usecase: PlaylistUsecase { get }
}

protocol PlaylistUsecase {
    func loadPlaylist() -> AnyPublisher<[HomePlaylistPresentable], Error>
}

struct RecentlyPlaylistUsecase: PlaylistUsecase {
    func loadPlaylist() -> AnyPublisher<[HomePlaylistPresentable], Error> {
        return Future({ promise in
            promise(.success([MockHomePlaylist(title: "최근 플레이리스트 1", isMemoed: false, youtubeTags: ["태그테스트 태그테스트", "태그테스트", "태그"]),
                              MockHomePlaylist(title: "최근 플레이리스트 1", isMemoed: true, youtubeTags: []),
                              MockHomePlaylist(title: "최근 플레이리스트 1", isMemoed: false, youtubeTags: [])]))
        }) .eraseToAnyPublisher()
    }
}

struct PopularPlaylistUsecase: PlaylistUsecase {
    func loadPlaylist() -> AnyPublisher<[HomePlaylistPresentable], Error> {
        return Future({ promise in
            promise(.success([MockHomePlaylist(title: "인기 플레이리스트 1", isMemoed: false, youtubeTags: []),
                              MockHomePlaylist(title: "인기 플레이리스트 2", isMemoed: false, youtubeTags: ["태그테스트 태그테스트", "태그테스트", "태그"]),
                              MockHomePlaylist(title: "인기 플레이리스트 3", isMemoed: false, youtubeTags: [])]))
        }) .eraseToAnyPublisher()
    }
}

struct FavoritePlaylistUsecase: PlaylistUsecase {
    func loadPlaylist() -> AnyPublisher<[HomePlaylistPresentable], Error> {
        return Future({ promise in
            promise(.success([MockHomePlaylist(title: "취향 플레이리스트 1", isMemoed: false, youtubeTags: []),
                              MockHomePlaylist(title: "취향 플레이리스트 2", isMemoed: false, youtubeTags: []),
                              MockHomePlaylist(title: "취향 플레이리스트 3", isMemoed: false, youtubeTags: ["태그테스트 태그테스트", "태그테스트", "태그"])]))
        }) .eraseToAnyPublisher()
    }
}

struct RecentlyHomeMenu: HomeMenu {

    var usecase: PlaylistUsecase = RecentlyPlaylistUsecase()
    let title: String = "최신"

}

struct PopularHomeMenu: HomeMenu {

    var usecase: PlaylistUsecase = PopularPlaylistUsecase()
    let title: String = "인기"
}

struct FavoriteHomeMenu: HomeMenu {

    var usecase: PlaylistUsecase =  FavoritePlaylistUsecase()
    let title: String = "내 취향"
}

open class HomeViewModel {
    let menus: [HomeMenu]


    var currentMenu = CurrentValueSubject<HomeMenu?, Never>(nil)
    var playlists = CurrentValueSubject<[HomePlaylistPresentable], Never>([])

    var refresh = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()


    init(menus: [HomeMenu]) {
        self.menus = menus
        currentMenu.send(menus.first)

        refresh
            .sink(receiveValue: { [weak self] in
                guard let self = self, let menu = self.currentMenu.value else { return }
                menu.usecase.loadPlaylist()
                    .sink(receiveCompletion: { [weak self] completion in
                        guard case let .failure(error) = completion else { return }
                        self?.playlists.send([])
                        print(error)
                    }, receiveValue: { [weak self] playlists in
                        self?.playlists.send(playlists)
                    })
                    .store(in: &self.cancellables)
            })
            .store(in: &cancellables)
    }
}
