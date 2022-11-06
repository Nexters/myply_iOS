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
import Share
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
        
        let tabBarController = MainTabBarController()
        
        if UserDefaults.standard.string(forKey: "device-token") == nil {
            UserDefaults.standard.set(UUID().uuidString, forKey: "device-token")
        }
        MyPlyTarget.deviceToken = "1234" // UserDefaults.standard.string(forKey: "device-token") ?? "" // test
        
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
