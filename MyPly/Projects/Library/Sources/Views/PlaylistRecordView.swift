//
//  PlaylistRecordView.swift
//  Library
//
//  Created by choidam on 2022/08/22.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit

class PlaylistRecordView: UIView {
    
    // MARK: UI
    
    private let contentView = UIView().then {
        $0.backgroundColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PlaylistRecordView {
    private func addViews(){
    }
    
    private func initLayout(){
        addViews()
        
        
    }
}
