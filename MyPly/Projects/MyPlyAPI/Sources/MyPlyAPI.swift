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
    case preferredMusics(nextToken: String?)
    case search(query: String, nextToken: String?, order: String)
    case memo(youtubeVideoID: String,  body: String?)
    case unMemo(youtubeVideoID: String)
}

extension MyPlyTarget: TargetType {
    public var baseURL: URL {
        return URL(string: "https://myply-server-rwwy3wj4sa-du.a.run.app/api/v1")!
    }

    public var path: String {
        switch self {
        case .musics: return "/musics"
        case .preferredMusics: return "/musics/preference"
        case .search: return "/musics/search"
        case .memo: return "/memos"
        case .unMemo(let youtubeVideoID): return "/memos/\(youtubeVideoID)"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .musics: return .get
        case .preferredMusics: return .get
        case .search: return .get
        case .memo: return .post
        case .unMemo: return .delete
        }
    }

    public var task: Task {

        var parameters: [String: Any] = [:]
        switch self {
        case .musics(let nextToken, let order):
            if let nextToken = nextToken {
                parameters["nextToken"] = nextToken
            }
            parameters["order"] = order
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .preferredMusics(let nextToken):
            if let nextToken = nextToken {
                parameters["nextToken"] = nextToken
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .search(let query, let nextToken, let order):
            if let nextToken = nextToken {
                parameters["nextToken"] = nextToken
            }
            parameters["order"] = order
            parameters["query"] = query
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .memo(let youtubeVideoID, let body):
            if let body = body {
                parameters["body"] = body
            }
            parameters["youtubeVideoID"] = youtubeVideoID
            return .requestCompositeParameters(bodyParameters: parameters, bodyEncoding: JSONEncoding.default, urlParameters: [:])
        case .unMemo:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }

    public var headers: [String: String]? {
        switch self {
        default:
            return ["Device-token": MyPlyTarget.deviceToken, "Content-Type": "application/json"]
        }
    }

    public var validationType: ValidationType {
      return .successCodes
    }

}

public extension JSONDecoder {
    public func decode<T: Decodable>(_ type: T.Type, from data: Data, keyPath: String) throws -> T {
        let toplevel = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
        if let nestedJson = (toplevel as AnyObject).value(forKeyPath: keyPath) {
            let nestedJsonData = try JSONSerialization.data(withJSONObject: nestedJson, options: .fragmentsAllowed)
            return try decode(type, from: nestedJsonData)
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Nested json not found for key path \"\(keyPath)\""))
        }
    }
}

public enum MyPlyAPIError: LocalizedError {
    case parseError
}
