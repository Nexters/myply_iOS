//
//  HomeViewController.swift
//  Home
//
//  Created by 최동규 on 2022/07/29.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import CommonUI
import UIKit

open class HomeViewController: UIViewController {

    @IBOutlet private weak var collectionView: TouchPassedCollectionView!
    @IBOutlet private weak var categoryHeaderStackView: UIStackView!

    open override func viewDidLoad() {
        super.viewDidLoad()

        let xib = UINib(nibName: PlaylistCell.identifier, bundle: CommonUIResources.bundle)

        collectionView.register(xib, forCellWithReuseIdentifier: PlaylistCell.identifier)

        collectionView.delegate = self
        collectionView.dataSource = self


        (1...10).forEach { int in
            let button = UIButton()
            button.setTitle("test\(int)", for: .normal)
            button.backgroundColor = .systemGray
            button.contentEdgeInsets = .init(top: 0, left: 7.5, bottom: 0, right: 7.5)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 36).isActive = true
            button.setTitleColor(.red, for: .highlighted)
            button.setTitleColor(.red, for: .focused)
            categoryHeaderStackView.addArrangedSubview(button)
        }

    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.bounds.width, height: 284)
    }

}

extension HomeViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistCell.identifier, for: indexPath) as? PlaylistCell else { return UICollectionViewCell() }
        cell.backgroundColor = .white
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewModel = PopupViewModel(title: "플레이리스트를 보관함에서 삭제할까요?", description: "작성된 감상 기록이 함께 삭제됩니다.", firstButtonModel: .init(title: "취소", style: .cancel), secondButtonModel: .init(title: "삭제", action: {  }))
        guard let vc = PopupViewController.create(viewModel: viewModel) else { return }
        present(vc, animated: true)

    }

}

extension HomeViewController {
    public static func create() -> HomeViewController? {
        let storyboard = UIStoryboard(name: "Home", bundle: .init(for: self))
        return storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController

    }
}
