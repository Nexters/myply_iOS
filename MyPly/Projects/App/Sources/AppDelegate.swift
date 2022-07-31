//
//  AppDelegate.swift
//  App
//
//  Created by 최동규 on 2022/07/28.
//

import UIKit
import Alamofire
import CommonUI
import Home
import Search
import Library
import MyPage

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let tabBarController = MainTabBarController()
        tabBarController.view.backgroundColor = .white

        let homeVC = HomeViewController.create()
        homeVC?.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), selectedImage: nil)

        let searchVC = SearchViewController()
        searchVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "magnifyingglass"), selectedImage: nil)

        let libraryVC = LibraryViewController()
        libraryVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "book"), selectedImage: nil)

        let myPageVC = MyPageViewController()
        myPageVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), selectedImage: nil)

        tabBarController.setViewControllers([homeVC, searchVC, libraryVC, myPageVC].compactMap { $0 }, animated: false)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }

}
