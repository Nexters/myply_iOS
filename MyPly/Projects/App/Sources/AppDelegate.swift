//
//  AppDelegate.swift
//  App
//
//  Created by 최동규 on 2022/07/28.
//

import UIKit
import CommonUI
import Home
import Search
import MyPlyAPI
import Library
import MyPage
import OnBoarding

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if let token = UserDefaults.standard.string(forKey: "device-token") {
            MyPlyTarget.deviceToken = "1234" // token
            let tabBarController = MainTabBarController()
            window?.rootViewController = tabBarController
        } else {
            UserDefaults.standard.set(UUID().uuidString, forKey: "device-token")
            let onBoardingViewController = OnBoardingViewController.create() ?? UIViewController()
            window?.rootViewController = onBoardingViewController
        }
        
        window?.makeKeyAndVisible()
        
        return true
    }
}

extension AppDelegate {
    func applicationDidFinishLaunching(_ application: UIApplication) {
        UILabel.appearance(whenContainedInInstancesOf: [UIView.self]).textColor = UIColor.gray80
    }
}
