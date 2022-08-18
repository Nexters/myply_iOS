//
//  Memo.swift
//  Model
//
//  Created by choidam on 2022/08/18.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

public struct Memo: Codable {
    let memoId: String
    let thumbnailURL: String
    let title: String
    let keywords: [String]
    let body: String
}
