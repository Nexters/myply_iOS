//
//  HomeViewController.swift
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

open class HomeViewController: UIViewController {

    @IBOutlet private weak var collectionView: TouchPassedCollectionView!
    @IBOutlet private weak var categoryHeaderStackView: UIStackView!
    private let viewModel: HomeViewModel
    private var cancellables = Set<AnyCancellable>()

    init?(coder: NSCoder, viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required public init?(coder: NSCoder) {
        fatalError("This viewController must be init with viewModel.")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        configureMenuButtons()

        let xib = UINib(nibName: PlaylistCell.identifier, bundle: CommonUIResources.bundle)
        collectionView.register(xib, forCellWithReuseIdentifier: PlaylistCell.identifier)
        collectionView.refreshControl = UIRefreshControl()
        collectionView.delegate = self
        collectionView.indicatorStyle = .black
        collectionView.dataSource = self
        view.backgroundColor = CommonUIAsset.begie.color

        configurePublisher()

    }
}

private extension HomeViewController {
    func configureMenuButtons() {
        viewModel.menus.forEach { menu in
            let button = HomeMenuButton()
            button.setTitle(menu.title, for: .normal)
            button.contentEdgeInsets = .init(top: 0, left: 7.5, bottom: 0, right: 7.5)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.titleLabel?.font = .systemFont(ofSize: 14)
            button.heightAnchor.constraint(equalToConstant: 36).isActive = true
            button.setTitleColor(.white, for: .selected)
            button.setTitleColor(CommonUIAsset.gray80.color, for: .normal)

            categoryHeaderStackView.addArrangedSubview(button)
            button.tapPublisher
                .sink { [weak self] in
                    self?.viewModel.currentMenu.send(menu)
                }.store(in: &cancellables)
        }


    }

    func configurePublisher() {
        viewModel.currentMenu
            .removeDuplicates(by: { lhs, rhs in
                guard let lhs = lhs , let rhs = rhs else { return  false}
                return lhs.title == rhs.title
            })
            .sink { [weak self] currentMenu in
                self?.categoryHeaderStackView.arrangedSubviews.forEach { view in
                    guard let menuButton = view as? HomeMenuButton, let currentMenu = currentMenu else { return }
                    menuButton.isSelected = currentMenu.title == menuButton.titleLabel?.text
                    self?.viewModel.refresh.send(())
                }
            }.store(in: &cancellables)

        viewModel.playlists
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
                self?.collectionView.refreshControl?.endRefreshing()
            }.store(in: &cancellables)

        collectionView.refreshControl?.isRefreshingPublisher
            .sink(receiveValue: { [weak self] isRefreshing in
                guard isRefreshing else { return }
                self?.viewModel.refresh.send(())
            })
            .store(in: &cancellables)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.collectionView.contentOffset.y > self.collectionView.contentSize.height - (self.collectionView.bounds.height + 100) && !self.viewModel.nextPageisLoading {
            self.viewModel.fetch.send()
            self.viewModel.nextPageisLoading = true
        }
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.bounds.width - 40, height: 284)
    }

}

extension HomeViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.playlists.value.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistCell.identifier, for: indexPath) as? PlaylistCell else { return UICollectionViewCell() }
        let item = viewModel.playlists.value[indexPath.item]
        cell.bind(to: viewModel.playlists.value[indexPath.item])

        cell.likeButton.tapPublisher
            .sink { [weak self] _ in
                guard let self = self,
                      let playlistModel = item as? Playlist else { return }
                playlistModel.isMemoed ? self.viewModel.unMemo.send(playlistModel.youtubeVideoID) : self.viewModel.memo.send(playlistModel.youtubeVideoID)

            }.store(in: &cell.cancellables)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.playlists.value[indexPath.item]
        guard let url = URL(string: item.videoDeepLink) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            let url = "itms-apps://itunes.apple.com/app/id544007664"
              if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
              }
        }
//        let viewModel = PopupViewModel(title: "플레이리스트를 보관함에서 삭제할까요?", description: "작성된 감상 기록이 함께 삭제됩니다.", firstButtonModel: .init(title: "취소", style: .cancel), secondButtonModel: .init(title: "삭제", action: {  }))
//        guard let vc = PopupViewController.create(viewModel: viewModel) else { return }
//        present(vc, animated: true)

    }

}

extension HomeViewController {
    public static func create() -> HomeViewController? {
        let storyboard = UIStoryboard(name: "Home", bundle: .init(for: self))
        let menus: [HomeMenu] = [RecentlyHomeMenu(), PopularHomeMenu(), FavoriteHomeMenu()]
        let viewModel = HomeViewModel(menus: menus)
        return storyboard.instantiateViewController(identifier: "HomeViewController") { coder in
            return HomeViewController(coder: coder, viewModel: viewModel)
        }

    }
}


final class HomeMenuButton: UIButton {
    override var isSelected: Bool {
        didSet {
            DispatchQueue.main.async {
                if self.isSelected {
                    self.backgroundColor = CommonUIAsset.greenLight.color
                } else {
                    self.backgroundColor = CommonUIAsset.gray30.color
                }
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setView()
    }

    func setView() {
        backgroundColor = CommonUIAsset.gray30.color
    }
}
