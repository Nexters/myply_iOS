//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 최동규 on 2022/07/23.
//

import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "App"
private let iOSTargetVersion = "14.0"

let infoPlist: [String: InfoPlist.Value] = [
    "CFBundleShortVersionString": "1.0",
    "CFBundleVersion": "1",
    "CFBundleDisplayName": "마이플리",
    "UILaunchStoryboardName": "LaunchScreen"
]

let project = Project.app(name: projectName,
                          platform: .iOS,
                          iOSTargetVersion: iOSTargetVersion,
                          infoPlist: infoPlist,
                          dependencies: [.external(name: "Alamofire"),
                                         .project(target: "Home", path: .relativeToCurrentFile("../Home")),
                                         .project(target: "Library", path: .relativeToCurrentFile("../Library")),
                                         .project(target: "MyPage", path: .relativeToCurrentFile("../MyPage")),
                                         .project(target: "Search", path: .relativeToCurrentFile("../Search"))])
