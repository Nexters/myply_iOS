//
//  AppDelegate.swift
//  OnBoarding
//
//  Created by 최모지 on 2022/07/30.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

@_exported import UIKit
@_exported import SnapKit
@_exported import Then

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = OnBoardingViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        return true
    }

}

