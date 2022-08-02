//
//  AppDelegate.swift
//  Search
//
//  Created by 최동규 on 2022/07/29.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = SearchViewController(keywordRepository: DummyKeywordRepositoryImpl())
        viewController.view.backgroundColor = .white
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        return true
    }
}

extension AppDelegate {
    func applicationDidFinishLaunching(_ application: UIApplication) {
        UILabel.appearance(whenContainedInInstancesOf: [UIView.self]).textColor = UIColor.gray80
        UITextField.appearance(whenContainedInInstancesOf: [UIView.self]).textColor = UIColor.gray80
    }
}

