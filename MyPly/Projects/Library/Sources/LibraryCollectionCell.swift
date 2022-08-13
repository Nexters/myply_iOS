//
//  LibraryCollectionCell.swift
//  Library
//
//  Created by 최모지 on 2022/08/13.
//

import UIKit
import CommonUI
import SnapKit
import Then

class LibraryCollectionCell: UICollectionViewCell {
    
    // MARK: UI
    
    private let cellView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let imageView = UIImageView().then {
        $0.backgroundColor = .systemYellow
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "playlist / 꽃향기를 닮은 음악 (songs scent like flower) 두줄테슽테스트테스트테스트테스트ㅜ"
        $0.numberOfLines = 2
        $0.font = .systemFont(ofSize: 14, weight: .bold)
        $0.textColor = CommonUIAsset.gray80.color
    }
    
    private let divideView = UIView().then {
        $0.backgroundColor = CommonUIAsset.gray50.color
    }
    
    private let editImageView = UIImageView().then {
        $0.image = UIImage(named: "editIcon")
    }
    
    private let memoLabel = UILabel().then {
        $0.text = "단순히 청량하다,청춘같다 라는 말로는 다 못 표현할 그런게 있어 진짜... 테스트테트스틑테ㅔ테테테테ㅔ텥테테"
        $0.numberOfLines = 2
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = CommonUIAsset.gray80.color
    }
    
    // MARK: Property
    
    private let identifier = "libraryCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LibraryCollectionCell {
    private func addViews(){
        addSubview(cellView)
        
        cellView.addSubview(imageView)
        cellView.addSubview(titleLabel)
        cellView.addSubview(divideView)
        cellView.addSubview(editImageView)
        cellView.addSubview(memoLabel)
    }
    
    private func initLayout(){
        addViews()
        
        backgroundColor = CommonUIAsset.greenLight.color
        
        cellView.snp.makeConstraints {
            $0.top.equalTo(16)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(180)
        }
        
        imageView.snp.makeConstraints {
            $0.top.leading.equalTo(16)
            $0.width.equalTo(132)
            $0.height.equalTo(78)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(16)
            $0.leading.equalTo(imageView.snp.trailing).offset(12)
            $0.trailing.equalTo(-15)
        }
        
        divideView.snp.makeConstraints {
            $0.leading.equalTo(16)
            $0.trailing.equalTo(-16)
            $0.height.equalTo(1)
            $0.top.equalTo(imageView.snp.bottom).offset(14)
        }
        
        editImageView.snp.makeConstraints {
            $0.top.equalTo(divideView.snp.bottom).offset(15)
            $0.leading.equalTo(16)
            $0.width.height.equalTo(24)
        }
        
        memoLabel.snp.makeConstraints {
            $0.top.equalTo(divideView.snp.bottom).offset(15)
            $0.leading.equalTo(editImageView.snp.trailing).offset(12)
            $0.trailing.equalTo(-16)
            $0.bottom.equalTo(-16)
        }
    }
}
