//
//  ShareViewController.swift
//  Home
//
//  Created by 최동규 on 2022/07/29.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import CommonUI
import UIKit
import Combine
import ModelIO
import CombineCocoa
import Model
import Kingfisher

open class ShareViewController: UIViewController {

    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var colorMenuCollectionView: UICollectionView!
    private var cancellables = Set<AnyCancellable>()

    private let viewModel: ShareViewModel

    init?(coder: NSCoder, viewModel: ShareViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required public init?(coder: NSCoder) {
        fatalError("This viewController must be init with viewModel.")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.setImage(CommonUIAsset.closeIcon.image, for: .normal)
        userNameLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.font = .systemFont(ofSize: 16 ,weight: .bold)
        titleLabel.font = .systemFont(ofSize: 14)
        imageView.contentMode = .scaleAspectFill
        colorMenuCollectionView.delegate = self
        colorMenuCollectionView.backgroundColor = .clear
        colorMenuCollectionView.dataSource = self
        colorMenuCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "colorCell")
        backgroundView.layer.borderWidth = 1
        backgroundView.layer.borderColor = CommonUIColors.Color.gray50?.cgColor
        bindViewModel()
        setPublisher()
    }
}

private extension ShareViewController {

    func setPublisher() {
        shareButton.tapPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                let image = self.backgroundView.asImage()
                guard  let vc = ShareBottomSheetController.create(image: image, color: self.viewModel.currentColorMenu.value) else { return }
                vc.modalTransitionStyle = .coverVertical
                self.present(vc, animated: true)
            }.store(in: &cancellables)

        closeButton.tapPublisher
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }.store(in: &cancellables)
    }

    func bindViewModel() {
        viewModel.shareItem
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                guard let self = self, let item = item else { return }
                self.userNameLabel.text = "\(item.userName)의 기억에 남은 Playlist"
                self.titleLabel.text = item.title

                self.descriptionLabel.text = item.description
                self.imageView.kf.setImage(with: item.imageURL)
            }.store(in: &cancellables)

        viewModel.currentColorMenu
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                guard let self = self else { return }
                self.backgroundView.backgroundColor = item.backgroundColor
                self.titleLabel.textColor = item.labelColor
                self.descriptionLabel.textColor = item.labelColor
                self.userNameLabel.textColor = item.labelColor
            }.store(in: &cancellables)
    }
}

extension ShareViewController: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 32, height: 32)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 19
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.colorMenus[indexPath.item]
        viewModel.currentColorMenu.send(item)
        collectionView.reloadData()
    }
}

extension ShareViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.colorMenus.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath)
        let item = viewModel.colorMenus[indexPath.item]
        cell.backgroundColor = item.backgroundColor
        cell.layer.cornerRadius = 16
        cell.layer.borderWidth = viewModel.currentColorMenu.value.isEqual(item) ? 3 : 0.5
        cell.layer.borderColor = viewModel.currentColorMenu.value.isEqual(item) ? CommonUIColors.Color.gray90?.cgColor : CommonUIColors.Color.gray50?.cgColor

        return cell
    }


}

extension ShareViewController {
    public static func create() -> ShareViewController? {
        let storyboard = UIStoryboard(name: "Share", bundle: .init(for: self))
        let viewModel = ShareViewModel()
        return storyboard.instantiateViewController(identifier: "ShareViewController") { coder in
            return ShareViewController(coder: coder, viewModel: viewModel)
        }

    }
}

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
