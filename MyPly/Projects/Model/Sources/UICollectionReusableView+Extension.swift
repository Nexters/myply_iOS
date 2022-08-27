//
//  UICollectionReusableView+Extension.swift
//  Model
//
//  Created by nylah.j on 2022/08/24.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit

public extension UICollectionReusableView {
    static var identifier: String {
        String(describing: Self.self)
    }
    public static var nibName: String { String(describing: Self.self) }
}

