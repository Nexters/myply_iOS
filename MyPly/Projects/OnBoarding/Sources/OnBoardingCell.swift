//
//  OnBoardingCell.swift
//  OnBoarding
//
//  Created by 최모지 on 2022/08/11.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

final class OnBoardingCell: UICollectionViewCell {
    
    // MARK: UI
    
    private let imageView = UIImageView().then {
        $0.backgroundColor = .systemBlue
    }
    
    private let descLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.text = "테스트테스트테스ㅡ트트ㅡ트테테테네네네ㅔ테테텡ㅇㅇㅇㅇㅇㅇ"
    }
    
    // MARK: Property
    
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
        addViews()
        
        imageView.snp.makeConstraints {
            $0.top.leading.equalTo(32)
            $0.trailing.equalTo(-32)
            $0.height.equalTo(360)
        }
        
        descLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(41)
            $0.leading.equalTo(21)
            $0.trailing.equalTo(-21)
        }
    }
}
