//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 최동규 on 2022/07/23.
//

import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "Search"
private let iOSTargetVersion = "14.0"

let infoPlist: [String: InfoPlist.Value] = [
    "CFBundleShortVersionString": "1.0",
    "CFBundleVersion": "1",
    "UILaunchStoryboardName": "LaunchScreen"
]

let project = Project.frameworkWithDemoApp(name: projectName,
                                           platform: .iOS,
                                           iOSTargetVersion: iOSTargetVersion,
                                           infoPlist: infoPlist,
                                           dependencies: [.project(target: "CommonUI", path: .relativeToCurrentFile("../CommonUI")),
                                                          .external(name: "Alamofire"),
                                                          .external(name: "SnapKit"),
<<<<<<< HEAD
                                                          .external(name: "CombineCocoa"),
                                                          .project(target: "Model", path: .relativeToCurrentFile("../Model"))])
=======
                                                          .external(name: "CombineCocoa")])
>>>>>>> 9b472e5 (mypage: edit 아이콘 추가)

