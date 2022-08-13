//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 최동규 on 2022/07/23.
//

import ProjectDescriptionHelpers
import ProjectDescription

private let projectName = "MyPlyAPI"
private let iOSTargetVersion = "14.0"
let project = Project.framework(name: projectName, platform: .iOS, iOSTargetVersion: iOSTargetVersion, dependencies: [.external(name: "Alamofire")])
