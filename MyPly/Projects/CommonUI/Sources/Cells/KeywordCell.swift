//
//  KeywordCell.swift
//  Search
//
//  Created by nylah.j on 2022/08/02.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit
import Model

open class KeywordCell: UICollectionViewCell {
    public enum Constants {
       public static let reuseIdentifier: String = .init(describing: KeywordCell.self)
    }

    @IBOutlet weak var keywordLabel: UILabel!
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        keywordLabel.font = .systemFont(ofSize: 14)
        // Initialization code
    }
    
    open func setKeyword(with keyword: Keyword) {
        keywordLabel.text = KeywordText(keyword: keyword).value
        self.sizeToFit()
        layoutIfNeeded()
    }
    
    open func setBackgroundColor(_ color: UIColor) {
        contentView.backgroundColor = color
        keywordLabel.backgroundColor = .clear
    }
    
    public static func fittingSize(availableHeight: CGFloat, keyword: Keyword) -> CGSize {
        let cell = KeywordCell()
        
        let targetSize: CGSize = .init(width: UIView.layoutFittingCompressedSize.width, height: availableHeight)
        return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
       }
}
