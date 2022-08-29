//
//  UpdateKeywordUsecase.swift
//  Home
//
//  Created by nylah.j on 2022/08/27.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Foundation
import Model

public protocol UpdateKeywordUsecase {
    func execute(keywords: Keywords) async throws -> Bool
}

public class DefaultUpdateKeywordUseCase: UpdateKeywordUsecase {
    let repository: MemberRepository
    
    public init(repository: MemberRepository) {
        self.repository = repository
    }
    
    public func execute(keywords: Keywords) async throws -> Bool {
        // TODO: name을 userdefault 값으로 수정하기
        try await repository.updateMemberInfo(name: "dummyname", keyword: keywords)
    }
}
