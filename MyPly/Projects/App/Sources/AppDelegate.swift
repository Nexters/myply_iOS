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
import MyPlyAPI
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
        tabBarController.tabBar.tintColor = .darkGray
        tabBarController.view.backgroundColor = .white

        if UserDefaults.standard.string(forKey: "device-token") == nil {
            UserDefaults.standard.set(UUID().uuidString, forKey: "device-token")
        }
        MyPlyTarget.deviceToken = UserDefaults.standard.string(forKey: "device-token") ?? ""

        let homeVC = HomeViewController.create()
        homeVC?.tabBarItem = UITabBarItem(title: nil, image: AppAsset.home.image, selectedImage: nil)

        let searchVC = SearchViewController()
        searchVC.tabBarItem = UITabBarItem(title: nil, image: AppAsset.search.image, selectedImage: nil)

        let libraryVC = LibraryViewController()
        libraryVC.tabBarItem = UITabBarItem(title: nil, image: AppAsset.keep.image, selectedImage: nil)

        let myPageVC = MyPageViewController()
        myPageVC.tabBarItem = UITabBarItem(title: nil, image: AppAsset.myPage.image, selectedImage: nil)

        tabBarController.setViewControllers([homeVC, searchVC, libraryVC, myPageVC].compactMap { $0 }, animated: false)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }
}

extension AppDelegate {
    func applicationDidFinishLaunching(_ application: UIApplication) {
        UILabel.appearance(whenContainedInInstancesOf: [UIView.self]).textColor = UIColor.gray80
    }
}
