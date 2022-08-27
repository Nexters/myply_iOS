//
//  MyPageItems.swift
//  MyPage
//
//  Created by nylah.j on 2022/08/22.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Foundation

enum MyPageItems {
    static let value: [MyPageItem] = ServiceInfoItems.value + CustomerServiceItems.value
}


enum ServiceInfoItems {
    static let header: String = "서비스 정보"
    static let value: [MyPageItem] = [
        .init(title: "앱 버전", content: .value("1.0")),
        .init(title: "만든 사람들", content: .image),
        .init(title: "Open Source License", content: .image)
    ]
    
    static func isLast(item: MyPageItem) -> Bool {
        value.last == item
    }
}

enum CustomerServiceItems {
    static let header: String = "사용자 지원"
    static let value: [MyPageItem] = [
        .init(title: "닉네임 수정", content: .image),
        .init(title: "문의하기", content: .image)
    ]
    
    static func isLast(item: MyPageItem) -> Bool {
        value.last == item
    }
}

enum Content: Equatable {
    case image
    case value(String)
}

struct MyPageItem: Equatable {
    let title: String
    let content: Content
}




