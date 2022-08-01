//
//  KeywordView.swift
//  SearchDemoApp
//
//  Created by nylah.j on 2022/08/01.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit

class KeywordView: UIView {
    private enum Constants {
        static let keywordFormat = "#%@"
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
    
    func setKeyword(with content: String) {
        let keywordLabelValue = keywordLabelValue(with: content)
        keywordLabel.text = keywordLabelValue
    }
    
    private func keywordLabelValue(with content: String) -> String {
        String(format: Constants.keywordFormat, arguments: [content])
    }
}
