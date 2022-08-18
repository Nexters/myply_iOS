//
//  AppDelegate.swift
//  LibraryDemoApp
//
//  Created by 최동규 on 2022/07/29.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

@_exported import CommonUI
@_exported import Model
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
        let viewController = LibraryViewController.create() ?? UIViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        return true
    }

}
