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

    enum CodingKeys: String, CodingKey {
        case isMemoed
        case thumbnailURL
        case title
        case videoDeepLink
        case youtubeTags
        case youtubeVideoID
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isMemoed = (try? container.decode(Bool.self, forKey: .isMemoed)) ?? false
        thumbnailURL = (try? container.decode(String.self, forKey: .thumbnailURL)) ?? ""
        title = (try? container.decode(String.self, forKey: .title)) ?? ""
        videoDeepLink = (try? container.decode(String.self, forKey: .videoDeepLink)) ?? ""
        youtubeTags = (try? container.decode([String].self, forKey: .youtubeTags)) ?? []
        youtubeVideoID = (try? container.decode(String.self, forKey: .youtubeVideoID)) ?? ""
    }
}
