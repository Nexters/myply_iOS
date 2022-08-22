//
//  LibraryDetailViewController.swift
//  Library
//
//  Created by choidam on 2022/08/18.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Foundation
import UIKit
import CommonUI

open class LibraryDetailViewController: UIViewController {
    
    // MARK: UI
    
    private let scrollView = UIScrollView().then {
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.backgroundColor = CommonUIAsset.begie.color
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    private let cardView = PlaylistCardView()
    
    private let recordView = PlaylistRecordView()
    
    // MARK: Property
    
    private let viewModel: LibraryDetailViewModel
    
    init(viewModel: LibraryDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        initLayout()
    }
    
}

extension LibraryDetailViewController {
    
    public static func create() -> LibraryDetailViewController? {
        let viewModel = LibraryDetailViewModel()
        let libraryDetailVC = LibraryDetailViewController(viewModel: viewModel)
        
        return libraryDetailVC
    }
    
    private func setNavigationBar(){
        self.title = "기록 보기"
        
    }
    
    private func addViews(){
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubview(cardView)
        stackView.addArrangedSubview(recordView)
    }
    
    private func initLayout(){
        setNavigationBar()
        addViews()
        
        view.backgroundColor = CommonUIAsset.begie.color
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.lessThanOrEqualToSuperview().priority(.low)
        }
        
    }
}
