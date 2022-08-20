//
//  APIResponse.swift
//  Model
//
//  Created by 최동규 on 2022/08/20.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Foundation

public struct APIResponse<T: Codable>: Codable {
    public let code: Int
    public let data: T
    public let message: String
}
