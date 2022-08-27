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

let infoPlistPath: String = "Resources/App.plist"

let project = Project.app(name: projectName,
                          platform: .iOS,
                          iOSTargetVersion: iOSTargetVersion,
                          infoPlist: infoPlistPath,
                          dependencies: [.external(name: "Moya"),
                                         .external(name: "SnapKit"),
                                         .external(name: "Then"),
                                         .project(target: "OnBoarding", path: .relativeToCurrentFile("../OnBoarding")),
                                         .project(target: "SignUp", path: .relativeToCurrentFile("../SignUp")),
                                         .project(target: "Home", path: .relativeToCurrentFile("../Home")),
                                         .project(target: "Library", path: .relativeToCurrentFile("../Library")),
                                         .project(target: "MyPage", path: .relativeToCurrentFile("../MyPage")),
                                         .project(target: "Search", path: .relativeToCurrentFile("../Search")),
                                         .project(target: "MyPlyAPI", path: "../MyPlyAPI")])
