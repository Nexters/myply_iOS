//
//  PlaylistRepository.swift
//  Search
//
//  Created by nylah.j on 2022/08/13.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

public protocol PlaylistRepository {
    func search(param: String) async throws -> [Playlist]
}

public class DummyPlaylistRepositoryImpl : PlaylistRepository {
    public init() {}
    
    public func search(param: String) async throws -> [Playlist] {
        return [
            .init(isMemoed: false, thumbnailURL: "", title: "첫번째 플레이리스트", videoDeepLink: "deep link", youtubeTags: ["tag1", "tag2"], youtubeVideoID: "viedo id")
        ]
    }
}
