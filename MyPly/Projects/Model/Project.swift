//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 최동규 on 2022/07/23.
//

import ProjectDescriptionHelpers
import ProjectDescription

private let projectName = "Model"
private let iOSTargetVersion = "14.0"
let project = Project.framework(name: projectName, platform: .iOS, iOSTargetVersion: iOSTargetVersion, dependencies: [.project(target: "MyPlyAPI", path: .relativeToCurrentFile("../MyPlyAPI"))])
