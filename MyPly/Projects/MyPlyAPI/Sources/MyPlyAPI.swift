//
//  MyPlyAPI.swift
//  MyPlyAPI
//
//  Created by 최동규 on 2022/07/29.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Foundation
import Moya

public enum MyPlyTarget {
    public static var deviceToken = ""
    case musics(nextToken: String?, order: String)
    case search(query: String, nextToken: String?, order: String)
}

extension MyPlyTarget: TargetType {
    public var baseURL: URL {
        return URL(string: "https://myply-server-rwwy3wj4sa-du.a.run.app/api/v1")!
    }

    public var path: String {
        switch self {
        case .musics: return "/musics"
        case .search: return "/musics/search"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .musics: return .get
        case .search: return .get
        }
    }

    public var task: Task {
        switch self {
        case .musics(nextToken: let nextToken, order: let order):
            return .requestParameters(parameters: ["nextToken": nextToken, "order": order], encoding: URLEncoding.default)
        case .search(let query, let nextToken, let order):
            return .requestParameters(parameters: ["query": query, "nextToken": nextToken, "order": order], encoding: URLEncoding.default)
        }
    }

    public var headers: [String: String]? {
        switch self {
        default:
            return ["device-token": MyPlyTarget.deviceToken, "Content-Type": "application/json"]
        }
    }

    public var validationType: ValidationType {
      return .successCodes
    }

}
