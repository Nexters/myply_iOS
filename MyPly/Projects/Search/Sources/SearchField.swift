//
//  SearchField.swift
//  Search
//
//  Created by nylah.j on 2022/08/13.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Foundation
import UIKit

class SearchField: UITextField {
    let padding = UIEdgeInsets(top: 15, left: 30, bottom: 15, right: 0);
    
    let searchView = UIImageView(image: UIImage.search)
    
    init() {
        super.init(frame: .zero)
        self.leftViewMode = .always
        self.leftView = searchView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
