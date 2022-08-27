//
//  OnBoardingModel.swift
//  OnBoarding
//
//  Created by 최모지 on 2022/08/27.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

struct OnBoardingModel {
    let desc: String
    let image: UIImage
    
    static func modelList() -> [OnBoardingModel] {
        var modelLists: [OnBoardingModel] = []
        
        let descriptions: [String] = [
            "유튜브 영상 플레이리스트를\n한 곳에서 모아볼 수 있어요.",
            "내 취향에 맞는 플레이리스트를\n키워드 검색을 통해 찾을 수 있어요.",
            "플레이리스트에 대한 내 생각을\n기록하고 공유할 수 있어요."
        ]

        for (index, element) in descriptions.enumerated() {
            modelLists.append(OnBoardingModel(desc: element, image: UIImage(named: "onBoarding\(index+1)", in: OnBoardingResources.bundle, with: nil) ?? UIImage()))
        }
        
        return modelLists
    }
}
