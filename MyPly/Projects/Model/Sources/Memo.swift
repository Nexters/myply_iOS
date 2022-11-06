//
//  Memo.swift
//  Model
//
//  Created by choidam on 2022/08/18.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

public struct Memo: Codable {
    public var body: String?
    public var keywords: [String]?
    public var memoID: String?
    public var thumbnailURL: String?
    public var title: String?
    public var youtubeVideoID: String?
}
