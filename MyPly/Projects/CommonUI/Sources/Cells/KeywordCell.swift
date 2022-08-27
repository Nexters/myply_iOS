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
    }
    
    open func setKeyword(with keyword: Keyword) {
        keywordLabel.text = KeywordText(keyword: keyword).value
    }
    
    open func setBackgroundColor(_ color: UIColor) {
        contentView.backgroundColor = color
        keywordLabel.backgroundColor = .clear
    }
    
    open func setWidth(_ width: CGFloat) {
        let originHeight = self.frame.size.height
        self.frame = .init(origin: .zero, size: .init(width: width, height: originHeight))
    }
    
    public static func fittingSize(availableHeight: CGFloat, keyword: Keyword) -> CGSize {
        let cell = KeywordCell()
        
        let targetSize: CGSize = .init(width: UIView.layoutFittingCompressedSize.width, height: availableHeight)
        return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
       }
}
