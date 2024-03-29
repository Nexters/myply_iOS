//
//  LibraryCollectionCell.swift
//  Library
//
//  Created by 최모지 on 2022/08/13.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Kingfisher
import CommonUI

class LibraryCollectionCell: UICollectionViewCell {
    
    // MARK: UI
    
    private let cellView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let imageView = UIImageView().then {
        $0.backgroundColor = .systemYellow
    }
    
    private let likeButton = UIButton().then {
        $0.setImage(UIImage(named: "likeSelected"), for: .normal)
    }
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.font = .systemFont(ofSize: 14, weight: .bold)
        $0.textColor = CommonUIAsset.gray80.color
    }
    
    private var collectionView: UICollectionView!
    
    private let divideView = UIView().then {
        $0.backgroundColor = CommonUIAsset.gray50.color
    }
    
    private let editImageView = UIImageView().then {
        $0.image = LibraryAsset.editIcon.image
    }
    
    private let memoLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = CommonUIAsset.gray80.color
    }
    
    // MARK: Property
    
    var title: String = "" {
        didSet {
            bindInfo()
        }
    }
    
    var memo: String = "" {
        didSet {
            bindInfo()
        }
    }
    
    var thumbnail: String = "" {
        didSet {
            bindInfo()
        }
    }
    
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
        imageView.addSubview(likeButton)
        cellView.addSubview(titleLabel)
        cellView.addSubview(collectionView)
        cellView.addSubview(divideView)
        cellView.addSubview(editImageView)
        cellView.addSubview(memoLabel)
    }
    
    private func initLayout(){
        initCollectionView()
        addViews()
        
        backgroundColor = CommonUIAsset.begie.color
        
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
        
        likeButton.snp.makeConstraints {
            $0.top.leading.equalTo(8)
            $0.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(16)
            $0.leading.equalTo(imageView.snp.trailing).offset(12)
            $0.trailing.equalTo(-15)
        }
        
        collectionView.snp.makeConstraints {
            $0.bottom.equalTo(divideView.snp.top).offset(-14)
            $0.height.equalTo(20)
            $0.leading.equalTo(imageView.snp.trailing).offset(16)
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
    
    private func initCollectionView(){
        let flowLayout = UICollectionViewFlowLayout().then {
            $0.scrollDirection = .vertical
            $0.minimumLineSpacing = 0
            $0.minimumInteritemSpacing = 0
        }
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
        }
    }
    
    private func bindInfo(){
        titleLabel.text = title
        
        let thumnailURL = URL(string: thumbnail)
        imageView.kf.setImage(with: thumnailURL)
        
        if memo.count == 0 {
            editImageView.image = LibraryAsset.editGrayIcon.image
            memoLabel.text = "나의 기록을 입력해 주세요.\n"
            memoLabel.textColor = CommonUIAsset.gray50.color
        } else {
            editImageView.image = LibraryAsset.editIcon.image
            memoLabel.text = memo
            memoLabel.textColor = CommonUIAsset.gray80.color
        }
    }
}
