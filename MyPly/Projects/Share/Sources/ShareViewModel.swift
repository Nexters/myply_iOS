//
//  ShareViewModel.swift
//  Home
//
//  Created by 최동규 on 2022/08/06.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Foundation
import Combine
import CommonUI
import Moya
import MyPlyAPI
import UIKit

protocol SharePresentable {
    var userName: String { get }
    var imageURL: URL? { get }
    var title: String { get }
    var description: String { get }
}

protocol ShareColorMenu {
    var labelColor: UIColor { get }
    var backgroundColor: UIColor { get }
}

extension ShareColorMenu {

    func isEqual(_ other: ShareColorMenu) -> Bool {
        return type(of: self) == type(of: other)
    }
}

struct WhiteShareColorMenu: ShareColorMenu {
    var labelColor: UIColor = .black
    var backgroundColor: UIColor = .white
}

struct DarkGreenhareColorMenu: ShareColorMenu {
    var labelColor: UIColor = .black
    var backgroundColor: UIColor = #colorLiteral(red: 0.2941176471, green: 0.3568627451, blue: 0.3333333333, alpha: 1)
}
struct GreenShareColorMenu: ShareColorMenu {
    var labelColor: UIColor = .white
    var backgroundColor: UIColor = #colorLiteral(red: 0.5058823529, green: 0.5921568627, blue: 0.5450980392, alpha: 1)
}
struct BlueShareColorMenu: ShareColorMenu {
    var labelColor: UIColor = .black
    var backgroundColor: UIColor = #colorLiteral(red: 0.5450980392, green: 0.6941176471, blue: 0.9254901961, alpha: 1)
}
struct RedShareColorMenu: ShareColorMenu {
    var labelColor: UIColor = .white
    var backgroundColor: UIColor = #colorLiteral(red: 0.8784313725, green: 0.5333333333, blue: 0.4392156863, alpha: 1)
}
struct YellowShareColorMenu: ShareColorMenu {
    var labelColor: UIColor = .black
    var backgroundColor: UIColor = #colorLiteral(red: 0.9647058824, green: 0.9254901961, blue: 0.7882352941, alpha: 1)
}
struct BrownShareColorMenu: ShareColorMenu {
    var labelColor: UIColor = .white
    var backgroundColor: UIColor = #colorLiteral(red: 0.5607843137, green: 0.5215686275, blue: 0.5098039216, alpha: 1)
}

struct MockShareItem: SharePresentable {
    let userName: String = "dochoi"
    let imageURL: URL? = URL(string: "https://avatars.githubusercontent.com/u/54564170?s=60&v=4")
    let title: String = "[플레이리스트] 좋은거"
    let description: String = "디스크립션"
}

open class ShareViewModel {

    let shareItem =  CurrentValueSubject<SharePresentable?, Never>(MockShareItem())
    let colorMenus: [ShareColorMenu] = [WhiteShareColorMenu(), DarkGreenhareColorMenu(), GreenShareColorMenu(), BlueShareColorMenu(), RedShareColorMenu(), YellowShareColorMenu(), BrownShareColorMenu()]
    let currentColorMenu =  CurrentValueSubject<ShareColorMenu, Never>(WhiteShareColorMenu())
}
