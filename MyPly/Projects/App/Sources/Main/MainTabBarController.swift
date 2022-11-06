//
//  MainTabBarController.swift
//  App
//
//  Created by 최동규 on 2022/07/28.
//

import Foundation
import UIKit
import Home
import Search
import Library
import MyPage


final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .darkGray
        view.backgroundColor = .white

        let homeVC = HomeViewController.create()
        homeVC?.tabBarItem = UITabBarItem(title: nil, image: AppAsset.home.image, selectedImage: nil)

        let searchVC = SearchViewController()
        searchVC.tabBarItem = UITabBarItem(title: nil, image: AppAsset.search.image, selectedImage: nil)

        let libraryVC = LibraryViewController.create()
        libraryVC?.tabBarItem = UITabBarItem(title: nil, image: AppAsset.keep.image, selectedImage: nil)

        let myPageVC = MyPageViewController.create()
        myPageVC.tabBarItem = UITabBarItem(title: nil, image: AppAsset.myPage.image, selectedImage: nil)

        setViewControllers([homeVC, searchVC, libraryVC, myPageVC].compactMap { $0 }, animated: false)
    }
}
