//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 최동규 on 2022/11/06.
//

import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "Share"
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
                          dependencies:  [
                            .project(target: "CommonUI",
                                     path: .relativeToCurrentFile("../CommonUI")),.external(name: "SnapKit"),
                                        .external(name: "Then")
                           ])
