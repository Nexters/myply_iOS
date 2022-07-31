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

    @IBOutlet weak var collectionView: UICollectionView!

    open override func viewDidLoad() {
        super.viewDidLoad()

        let xib = UINib(nibName: PlaylistCell.identifier, bundle: CommonUIResources.bundle)

        collectionView.register(xib, forCellWithReuseIdentifier: PlaylistCell.identifier)

        collectionView.delegate = self
        collectionView.dataSource = self
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
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistCell.identifier, for: indexPath) as? PlaylistCell else { return UICollectionViewCell() }

        return cell
    }


}

extension HomeViewController {
    public static func create() -> HomeViewController? {
        let storyboard = UIStoryboard(name: "Home", bundle: .init(for: self))
        return storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController

    }
}
