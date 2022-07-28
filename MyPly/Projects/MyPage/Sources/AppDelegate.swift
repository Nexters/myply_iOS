//
//  AppDelegate.swift
//  MyPageDemoApp
//
//  Created by 최동규 on 2022/07/29.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit
import MyPage

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = MyPageViewController()
        viewController.view.backgroundColor = .white
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        return true
    }

}
