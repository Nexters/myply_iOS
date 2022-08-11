//
//  OnBoardingViewController.swift
//  OnBoarding
//
//  Created by 최모지 on 2022/07/30.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit
import SnapKit
import Then


open class OnBoardingViewController: UIViewController {
    
    // MARK: UI
    
    private var collectionView: UICollectionView!

    private let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.backgroundColor = .systemGreen
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    // MARK: Property
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        initLayout()
    }
}

extension OnBoardingViewController {
    private func addViews(){
        view.addSubview(collectionView)
        view.addSubview(nextButton)
    }

    private func initLayout(){
        initCollectionView()
        addViews()

        collectionView.snp.makeConstraints {
            $0.top.equalTo(132)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(455)
        }

        nextButton.snp.makeConstraints {
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.bottom.equalTo(-56)
            $0.height.equalTo(56)
        }
    }

    private func initCollectionView(){
        let flowLayout = UICollectionViewFlowLayout().then {
            $0.scrollDirection = .horizontal
            $0.minimumLineSpacing = 0
            $0.minimumInteritemSpacing = 0
        }

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
            $0.backgroundColor = .systemGreen
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.isPagingEnabled = true
            $0.register(OnBoardingCell.self, forCellWithReuseIdentifier: "onBoardingCell")
        }

        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension OnBoardingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "onBoardingCell", for: indexPath) as! OnBoardingCell
        
        return cell
    }
}

extension OnBoardingViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.size.width
        let height: CGFloat = 519
        return CGSize(width: width, height: height)
    }
}
