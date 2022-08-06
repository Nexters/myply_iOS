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
        keywordLabel.text = keyword.value
        keywordLabel.sizeToFit()
        self.sizeToFit()
    }
    
    func setBackgroundColor(_ color: UIColor) {
        keywordLabel.backgroundColor = color
    }
}
