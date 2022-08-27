//
//  Playlist.swift
//  Playlist
//
//  Created by 최동규 on 2022/07/29.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Foundation

public struct Playlist: Codable {

    public let isMemoed: Bool
    public let thumbnailURL: String
    public let title: String
    public let videoDeepLink: String
    public let youtubeTags: [String]
    public let youtubeVideoID: String
}
