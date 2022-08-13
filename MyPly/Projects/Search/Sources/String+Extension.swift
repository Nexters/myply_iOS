//
//  String+Extension.swift
//  Search
//
//  Created by nylah.j on 2022/08/13.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

extension String {
    public var isEmptyOrBlank: Bool {
        let isBlank = trimmingCharacters(in: .whitespaces).isEmpty
        return self.isEmpty || isBlank
    }
}
