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

public protocol HomePlaylistPresentable {
    var title: String { get }
    var isMemoed: Bool { get }
    var youtubeTags: [String] { get }
}

open class PlaylistCell: UICollectionViewCell {

    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tagStackView: UIStackView!

    open override func awakeFromNib() {
        super.awakeFromNib()
        likeButton.setImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControl.State#>)
    }

    open func bind(to: HomePlaylistPresentable) {
        
    }
}
