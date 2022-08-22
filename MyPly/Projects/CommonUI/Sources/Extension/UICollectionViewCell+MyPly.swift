//
//  UICollectionViewCell+MyPly.swift
//  CommonUI
//
//  Created by 최동규 on 2022/07/30.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    public static var identifier: String { String(describing: Self.self) }
    public static var nibName: String { String(describing: Self.self) }
}
