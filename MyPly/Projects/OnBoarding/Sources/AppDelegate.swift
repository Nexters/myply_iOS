//
//  AppDelegate.swift
//  OnBoarding
//
//  Created by 최모지 on 2022/07/30.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

@_exported import CommonUI


@_exported import UIKit
@_exported import Combine
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
        
        let navigationController = UINavigationController()
        let viewController = OnBoardingViewController.create() ?? UIViewController()
        
        navigationController.pushViewController(viewController, animated: false)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }

}

