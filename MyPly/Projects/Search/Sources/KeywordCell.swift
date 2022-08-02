//
//  KeywordView.swift
//  SearchDemoApp
//
//  Created by nylah.j on 2022/08/01.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit

class KeywordCell: UICollectionReusableView {
    enum Constants {
        static let keywordFormat = "#%@"
        static let identifier = String(describing: KeywordCell.self)
    }
    
    @IBOutlet weak var keywordLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadXib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    private func loadXib() {
        let identifier = String(describing: type(of: self))
        let nibs = Bundle.main
            .loadNibNamed(identifier, owner: self, options: nil)
        
        guard let view = nibs?.first as? UIView else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func setKeyword(with keyword: Keyword) {
        let keywordLabelValue = keywordLabelValue(with: keyword.value)
        keywordLabel.text = keywordLabelValue
    }
    
    func setBackground(_ color: UIColor) {
        self.backgroundColor = color
    }
    
    private func keywordLabelValue(with content: String) -> String {
        String(format: Constants.keywordFormat, arguments: [content])
    }
}
