//
//  User.swift
//  Model
//
//  Created by 최모지 on 2022/11/06.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Foundation

public struct User: Codable {
    public let deviceToken: String?
    public let keywords: [String]?
    public let name: String?
}
