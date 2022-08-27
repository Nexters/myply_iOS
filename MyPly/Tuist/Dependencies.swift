//
//  Dependencies.swift
//  Config
//
//  Created by nylah.j on 2022/07/09.
//

import ProjectDescription

let dependencies = Dependencies(
     swiftPackageManager: .init(
         [
            .remote(url: "https://github.com/Alamofire/Alamofire", requirement: .upToNextMajor(from: "5.0.0")),
            .remote(url: "https://github.com/SnapKit/SnapKit", requirement: .upToNextMajor(from: "5.0.1")),
            .remote(url: "https://github.com/CombineCommunity/CombineCocoa", requirement: .upToNextMajor(from: "0.4.0")),
            .remote(url: "https://github.com/devxoul/Then", requirement: .upToNextMajor(from: "3.0.0")),
            .remote(url: "https://github.com/Moya/Moya.git", requirement: .upToNextMajor(from: "15.0.0")),
            .remote(url: "https://github.com/onevcat/Kingfisher.git", requirement: .upToNextMajor(from: "7.0.0"))
         ],
         productTypes: ["Moya": .framework, "Alamofire": .framework, "SnapKit": .framework, "CombineCocoa": .framework, "Then": .framework, "Kingfisher": .framework]
     ),
     platforms: [.iOS]
 )
