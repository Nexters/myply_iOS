//
//  KeywordDataSource.swift
//  SearchDemoApp
//
//  Created by nylah.j on 2022/08/01.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit

typealias KeywordDataSource = UICollectionViewDiffableDataSource<Int, String>
typealias SnapShot = NSDiffableDataSourceSnapshot<Int, String>

//class KeywordDataSource: NSObject {
//    fileprivate var keywords: [Keyword] = []
//    fileprivate var backgroundColors: [UIColor] {
//        KeywordColorFactory.create(keywords: keywords)
//    }
//
//    func setKeywords(_ value: [Keyword]) {
//        self.keywords = value
//    }
//}
//
//extension KeywordDataSource: UICollectionViewDiffableDataSource<KeywordSectionType, KeywordItemType> {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeywordCell.Constants.identifier, for: indexPath)
//        guard let cell = cell as? KeywordCell else{ return cell }
//
//        let keyword = keywords[indexPath.item]
//        let index = indexPath.item
//        cell.setKeyword(with: keyword)
//        cell.setBackground(backgroundColors[index])
//        return cell
//    }
//}
