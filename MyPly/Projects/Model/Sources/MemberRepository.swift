//
//  MemberRepository.swift
//  Model
//
//  Created by nylah.j on 2022/08/27.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Foundation

public protocol MemberRepository {
    func updateMemberInfo(name: String, keyword: Keywords) async throws -> Bool
}

public class DefaultMemberRepository {
    public func updateMemberInfo(name: String, keyword: Keywords) async throws -> Bool {
        // TODO: 서버 통신 구현
        return true
    }
}

public class DummyMemberRepository: MemberRepository {
    public init() {}
    
    public func updateMemberInfo(name: String, keyword: Keywords) async throws -> Bool {
        return false
    }
}

