//
//  KeywordCell.swift
//  Search
//
//  Created by nylah.j on 2022/08/02.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit

class KeywordCell: UICollectionViewCell {
    enum Constants {
        static let reuseIdentifier: String = .init(describing: KeywordCell.self)
    }

    @IBOutlet weak var keywordLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setKeyword(with keyword: Keyword) {
        keywordLabel.text = KeywordText(keyword: keyword).value
        self.sizeToFit()
        layoutIfNeeded()
    }
    
    func setBackgroundColor(_ color: UIColor) {
        keywordLabel.backgroundColor = color
    }
}

struct KeywordText {
    static let keywordFormat = "#%@"
    
    let value: String
    
    init(keyword: Keyword) {
        value = String(format: Self.keywordFormat, keyword.value)
    }
}
