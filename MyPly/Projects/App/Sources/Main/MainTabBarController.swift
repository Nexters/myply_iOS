//
//  MainTabBarController.swift
//  App
//
//  Created by 최동규 on 2022/07/28.
//

import Foundation
import UIKit
import Home
import Search
import Library
import MyPage
import Model
import CombineCocoa
import MyPlyAPI
import Moya
import OnBoarding

final class MainTabBarController: UITabBarController {

    // MARK: Property
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .darkGray
        view.backgroundColor = .white
        
        loadUserInfo()
            .sink(receiveCompletion: { [weak self] completion in
                guard case let .failure(error) = completion else { return }
                print(error)
                self?.navigateToOnBoarding()
            }, receiveValue: { [weak self] user in
                guard let self = self else { return }

                print("user: \(user)")
                self.setViews()
            })
            .store(in: &self.cancellables)
    }
}

extension MainTabBarController {
    private func setViews(){
        let homeVC = HomeViewController.create()
        homeVC?.tabBarItem = UITabBarItem(title: nil, image: AppAsset.home.image, selectedImage: nil)

        let searchVC = SearchViewController()
        searchVC.tabBarItem = UITabBarItem(title: nil, image: AppAsset.search.image, selectedImage: nil)

        let libraryVC = LibraryViewController.create()
        libraryVC?.tabBarItem = UITabBarItem(title: nil, image: AppAsset.keep.image, selectedImage: nil)

        let myPageVC = MyPageViewController.create()
        myPageVC.tabBarItem = UITabBarItem(title: nil, image: AppAsset.myPage.image, selectedImage: nil)

        setViewControllers([homeVC, searchVC, libraryVC, myPageVC].compactMap { $0 }, animated: false)
    }
    
    func loadUserInfo() -> AnyPublisher<User, Error> {
        let provider = MoyaProvider<MyPlyTarget>()
        MyPlyTarget.deviceToken = "1234" // test
        
        return Future({ promise in
            provider.request(.getUserInfo) { result in
                switch result {
                case .success(let response):
                    do {
                        let decoder = JSONDecoder()
                        let user = try decoder.decode(User.self, from: response.data, keyPath: "data")
                        promise(.success(user))
                    }
                    catch(let error) {
                        promise(.failure(error))
                    }

                    case .failure(let error):
                    promise(.failure(error))
                }
            }
        }) .eraseToAnyPublisher()
    }
    
    private func navigateToOnBoarding(){
        let onBoardingViewController = OnBoardingViewController.create() ?? UIViewController()
        self.navigationController?.pushViewController(onBoardingViewController, animated: true)
    }
}
