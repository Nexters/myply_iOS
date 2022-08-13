//
//  SearchPlayListUseCase.swift
//  Search
//
//  Created by nylah.j on 2022/08/13.
//  Copyright © 2022 cocaine.io. All rights reserved.
//


protocol SearchPlaylistUseCase {
    func execute(param: String) async throws -> [Playlist]
}

final class DefaultSearchPlaylistUsecase : SearchPlaylistUseCase {
    private let repository: PlaylistRepository
    
    init(repository: PlaylistRepository) {
        self.repository = repository
    }
    
    func execute(param: String) async throws -> [Playlist] {
        return try await repository.search(param: param)
    }
}
