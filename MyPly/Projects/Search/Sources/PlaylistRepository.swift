//
//  PlaylistRepository.swift
//  Search
//
//  Created by nylah.j on 2022/08/13.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

protocol PlaylistRepository {
    func search(param: String) async throws -> [Playlist]
}

class DummyPlaylistRepositoryImpl : PlaylistRepository {
    func search(param: String) async throws -> [Playlist] {
        return [
            .init(title: "첫번째 플레이리스트")
        ]
    }
}
