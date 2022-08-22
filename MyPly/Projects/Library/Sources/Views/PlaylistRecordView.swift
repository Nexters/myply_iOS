//
//  PlaylistRecordView.swift
//  Library
//
//  Created by choidam on 2022/08/22.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit
import CommonUI

class PlaylistRecordView: UIView {
    
    // MARK: UI
    
    private let contentView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "나의 감상 기록"
        $0.textColor = CommonUIAsset.gray80.color
        $0.font = .systemFont(ofSize: 14, weight: .bold)
    }
    
    private let editButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "editIcon"), for: .normal)
    }
    
    private let textField = UITextField().then {
        $0.placeholder = "플레이 리스트에 대한 나의 감상을 기록해 보세요."
        $0.borderStyle = .none
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
        addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(editButton)
        contentView.addSubview(textField)
    }
    
    private func initLayout(){
        addViews()
        
        contentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(16)
            $0.leading.equalTo(16)
        }
        
        editButton.snp.makeConstraints {
            $0.top.equalTo(16)
            $0.trailing.equalTo(-16)
            $0.width.height.equalTo(24)
        }
        
        textField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(16)
            $0.trailing.bottom.equalTo(-16)
        }
    }
}
