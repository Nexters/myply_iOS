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
import Moya
import MyPlyAPI
import Model

struct MockHomePlaylist: HomePlaylistPresentable {
    var title: String
    var isMemoed: Bool
    var thumbnailURL: String = ""
    var youtubeTags: [String]
    var videoDeepLink: String = ""
}

protocol HomeMenu {

    var title: String { get }
    var usecase: PlaylistUsecase { get }
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
    var fetch = PassthroughSubject<Void, Never>()
    var nextPageisLoading: Bool = false
    var nextToken: String? = nil

    init(menus: [HomeMenu]) {
        self.menus = menus
        currentMenu.send(menus.first)

        refresh
            .sink(receiveValue: { [weak self] in
                guard let self = self else { return }
                self.playlists.send([])
                self.nextToken = nil
                self.fetch.send(())
            })
            .store(in: &cancellables)

        fetch
            .throttle(for: 1, scheduler: DispatchQueue.main, latest: false)
            .sink(receiveValue: { [weak self] in
                guard let self = self, let menu = self.currentMenu.value else { return }
                menu.usecase.loadPlaylist(nextToken: self.nextToken)
                    .sink(receiveCompletion: { [weak self] completion in
                        guard case let .failure(error) = completion else { return }
                        self?.playlists.send([])
                        print(error)
                    }, receiveValue: { [weak self] (playlists, nextToken) in
                        guard let self = self else { return }
                        var newData = self.playlists.value
                            newData.append(contentsOf: playlists)
                        self.playlists.send(newData)
                        self.nextPageisLoading = false
                        self.nextToken = nextToken
                    })
                    .store(in: &self.cancellables)
            })
            .store(in: &cancellables)
    }
}
