//
//  PlaylistCell.swift
//  CommonUI
//
//  Created by 최동규 on 2022/07/30.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit
import Combine
import CombineCocoa
import Kingfisher
import Model

public protocol HomePlaylistPresentable {
    var title: String { get }
    var isMemoed: Bool { get }
    var thumbnailURL: String { get }
    var youtubeTags: [String] { get }
    var videoDeepLink: String { get }
}

open class PlaylistCell: UICollectionViewCell {

    @IBOutlet public weak var likeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    private var tags: [String] = []
    public var cancellables = Set<AnyCancellable>()

    open override func awakeFromNib() {
        super.awakeFromNib()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        tagCollectionView.isScrollEnabled = true
        tagCollectionView.showsHorizontalScrollIndicator = false


        let nibName = UINib(nibName: "KeywordCell", bundle: .init(for: KeywordCell.self))
        tagCollectionView.register(nibName, forCellWithReuseIdentifier: KeywordCell.Constants.reuseIdentifier)
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
        imageView.contentMode = .scaleAspectFill
        titleLabel.textColor = CommonUI.CommonUIAsset.gray70.color
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }

    open func bind(to playlist: HomePlaylistPresentable) {
        backgroundColor = .white
        likeButton.isSelected = playlist.isMemoed
        imageView.kf.setImage(with: URL(string: playlist.thumbnailURL))
        titleLabel.text = playlist.title
        tags = playlist.youtubeTags
        tagCollectionView.reloadData()
    }
}

extension PlaylistCell: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let label = UILabel()
        label.text = KeywordText(keyword: Keyword(tags[indexPath.item])).value
        label.font = .systemFont(ofSize: 14)
        label.sizeToFit()
        return .init(width: label.frame.width + 24, height: label.frame.height + 11)
    }
}

extension PlaylistCell: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeywordCell.Constants.reuseIdentifier, for: indexPath)

        guard let keywordCell = cell as? KeywordCell else {
            return cell
        }

            keywordCell.setKeyword(with: Keyword(tags[indexPath.item]) )
        keywordCell.setBackgroundColor(CommonUIAsset.brown.color)
        return keywordCell
    }


}
