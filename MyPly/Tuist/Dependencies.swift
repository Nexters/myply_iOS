//
//  Dependencies.swift
//  Config
//
//  Created by nylah.j on 2022/07/09.
//

import ProjectDescription

let dependencies = Dependencies(
    carthage: [],
    swiftPackageManager: [
        .remote(url: "https://github.com/Alamofire/Alamofire", requirement: .upToNextMajor(from: "5.0.0")),
        .remote(url: "https://github.com/SnapKit/SnapKit", requirement: .upToNextMajor(from: "5.0.1")),
        .remote(url: "https://github.com/devxoul/Then", requirement: .upToNextMajor(from: "3.0.0")),
    ],
    platforms: [.iOS]
)
