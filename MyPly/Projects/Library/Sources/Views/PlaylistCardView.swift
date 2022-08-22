//
//  PlaylistCardView.swift
//  Library
//
//  Created by choidam on 2022/08/22.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit
import CommonUI

class PlaylistCardView: UIView {
    
    // MARK: UI
    
    private let contentView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let imageView = UIImageView().then {
        $0.backgroundColor = CommonUIAsset.greenLight.color
    }
    
    private let playImageView = UIImageView().then {
        $0.image = UIImage(named: "playIcon")
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = CommonUIAsset.gray80.color
        $0.numberOfLines = 2
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.text = "그 시절 감성힙합 플레이리스트 2 l 프라이머리, 다이나믹듀오, 슈프림팀, 버벌진트테스트테텥테테ㅔ테테테테ㅔ테테ㅔ텥"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PlaylistCardView {
    private func addViews(){
        addSubview(contentView)
        
        contentView.addSubview(imageView)
        imageView.addSubview(playImageView)
        contentView.addSubview(titleLabel)
    }
    
    private func initLayout(){
        addViews()
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(16)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(15)
            $0.leading.equalTo(16)
            $0.trailing.equalTo(-16)
            $0.height.equalTo(177)
        }
        
        playImageView.snp.makeConstraints {
            $0.top.equalTo(9)
            $0.trailing.equalTo(-8)
            $0.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(9)
            $0.leading.equalTo(16)
            $0.trailing.equalTo(-16)
            $0.bottom.equalTo(-16)
        }
    }
}
