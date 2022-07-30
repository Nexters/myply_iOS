//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 최모지 on 2022/07/30.
//

import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "OnBoarding"
private let iOSTargetVersion = "14.0"

let infoPlist: [String: InfoPlist.Value] = [
    "CFBundleShortVersionString": "1.0",
    "CFBundleVersion": "1"
]
let project = Project.frameworkWithDemoApp(name: projectName, platform: .iOS, iOSTargetVersion: iOSTargetVersion, infoPlist: infoPlist, dependencies: [.project(target: "CommonUI", path: .relativeToCurrentFile("../CommonUI"))])
