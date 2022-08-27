//
//  OnBoardingCell.swift
//  OnBoarding
//
//  Created by 최모지 on 2022/08/11.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import CommonUI
import UIKit

final class OnBoardingCell: UICollectionViewCell {
    
    // MARK: UI
    
    private let imageView = UIImageView()
    
    private let descLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = CommonUIAsset.gray80.color
    }
    
    // MARK: Property
    
    var desc: String = "" {
        didSet {
            setContent()
        }
    }
    
    var image: String = "" {
        didSet {
            setContent()
        }
    }
    
    private let identifier = "onBoardingCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OnBoardingCell {
    private func addViews(){
        addSubview(imageView)
        addSubview(descLabel)
    }
    
    private func initLayout(){
        backgroundColor = CommonUIAsset.begie.color
        
        addViews()
        
        imageView.snp.makeConstraints {
            $0.top.leading.equalTo(32)
            $0.trailing.equalTo(-32)
            $0.height.equalTo(360)
        }
        
        descLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(48)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
        }
    }
    
    private func setContent(){
        descLabel.text = desc
        imageView.image = UIImage(named: image)
    }
}
