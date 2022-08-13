//
//  Playlist.swift
//  Playlist
//
//  Created by 최동규 on 2022/07/29.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Foundation

public struct Playlist: Codable {

    let isMemoed: Bool
    let thumbnailURL: String
    let title: String
    let videoDeepLink: String
    let youtubeTags: [String]
    let youtubeVideoID: String
}
