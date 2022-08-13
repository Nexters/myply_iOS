//
//  HomeViewModel.swift
//  Home
//
//  Created by 최동규 on 2022/08/06.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Foundation
import Combine

protocol HomePlaylistPresentable {

}

struct MockHomePlaylist: HomePlaylistPresentable {

}

protocol HomeMenu {

    var title: String { get }
    var repository: HomeRepository { get }
}

protocol HomeRepository {
    func loadPlaylist() -> AnyPublisher<HomePlaylistPresentable, Error>
}

struct RealHomeRepository: HomeRepository {
    func loadPlaylist() -> AnyPublisher<HomePlaylistPresentable, Error> {
        return Future({ promise in
            promise(.success(MockHomePlaylist()))
        }) .eraseToAnyPublisher()
    }
}

struct RecentlyHomeMenu: HomeMenu {
    var repository: HomeRepository = RealHomeRepository()
    let title: String = "최신"

}

struct PopularHomeMenu: HomeMenu {
    var repository: HomeRepository = RealHomeRepository()
    let title: String = "인기"
}

struct FavoriteHomeMenu: HomeMenu {
    var repository: HomeRepository =  RealHomeRepository()

    let title: String = "내 취향"
}

open class HomeViewModel {
    let menus: [HomeMenu]

    var currentMenu = CurrentValueSubject<HomeMenu?, Never>(nil)

    init(menus: [HomeMenu]) {
        self.menus = menus
        currentMenu.send(menus.first)
    }
}
