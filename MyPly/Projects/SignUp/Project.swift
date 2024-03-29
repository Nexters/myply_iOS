//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 최모지 on 2022/08/13.
//

import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "SignUp"
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
                                           dependencies: [
                                            .project(target: "CommonUI", path: .relativeToCurrentFile("../CommonUI")),
                                            .external(name: "SnapKit"),
                                            .external(name: "Then")
                                           ])

