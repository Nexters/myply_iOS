//
//  PlaylistRepository.swift
//  Search
//
//  Created by nylah.j on 2022/08/13.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

<<<<<<< HEAD
public protocol PlaylistRepository {
    func search(param: String) async throws -> [Playlist]
}

public class DummyPlaylistRepositoryImpl : PlaylistRepository {
    public init() {}
    
    public func search(param: String) async throws -> [Playlist] {
        return [
            .init(isMemoed: false, thumbnailURL: "", title: "첫번째 플레이리스트", videoDeepLink: "deep link", youtubeTags: ["tag1", "tag2"], youtubeVideoID: "viedo id")
=======
protocol PlaylistRepository {
    func search(param: String) async throws -> [Playlist]
}

class DummyPlaylistRepositoryImpl : PlaylistRepository {
    func search(param: String) async throws -> [Playlist] {
        return [
            .init(youtubeVideoId: "viedo id ", title: "첫번째 플레이리스트")
>>>>>>> 281bf7a (FetchKeywordsUseCase, KeywordRepository, PlaylistRepository를 Model 모듈로 옮김)
        ]
    }
}
