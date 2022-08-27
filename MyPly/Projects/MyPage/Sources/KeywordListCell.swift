//
//  KeywordListCell.swift
//  MyPage
//
//  Created by nylah.j on 2022/08/25.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit
import Model
import CommonUI

class KeywordListCell: UICollectionViewCell {
    var collectionView: UICollectionView!
    var dataSource: KeywordDataSource!
    var keywords: Keywords?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        let layout = LeftAlignedCollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
        
        
        let keywordCellNib = UINib(nibName: KeywordCell.nibName, bundle: .init(for: KeywordCell.self))
        let cellRegistration = UICollectionView.CellRegistration(cellNib: keywordCellNib) { (cell: UICollectionViewCell, indexPath: IndexPath, itemIdentifier: String) in
            guard let keywordCell = cell as? KeywordCell else { return }
            guard let keyword = self.keywords?[indexPath.item] else { return }
            
            keywordCell.setKeyword(with: keyword)
        }
        
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        collectionView.dataSource = dataSource
    }
    
    func layoutView() {
        self.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    
    override func sizeToFit() {
        let width = collectionView.contentSize.width
        let height = collectionView.contentSize.height
        self.frame = .init(origin: .zero, size: .init(width: width, height: height))
    }
    
    func setKeywords(keywords: Keywords) {
        self.keywords = keywords
        var snapShot = KeywordSnapShot()
        let keywordValues = keywords.map { $0.value }
        snapShot.appendSections([0])
        snapShot.appendItems(keywordValues)
        dataSource.apply(snapShot)
        layoutIfNeeded()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout : KeywordCell 크기 설정
extension KeywordListCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let keyword = keywords?[indexPath.row]
        else { return .zero }
        
        let label = UILabel()
        label.text = KeywordText(keyword: keyword).value
        label.font = .init(name: "Pretendard", size: 14)
        label.sizeToFit()
        return .init(width: label.frame.width + 24, height: label.frame.height + 11)
    }
}

