//
//  UITextField+Extension.swift
//  SearchDemoApp
//
//  Created by nylah.j on 2022/08/01.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit

extension UITextField {
    func setPlaceHolderColor(_ placeHolderColor: UIColor?) {
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [
                .foregroundColor: placeHolderColor
            ].compactMapValues({ $0 })
        )
    }
}
