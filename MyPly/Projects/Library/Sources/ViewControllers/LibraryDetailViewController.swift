//
//  LibraryDetailViewController.swift
//  Library
//
//  Created by choidam on 2022/08/18.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

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
        
        // test
        recordView.memo = "진짜 오아시스 정말 좋아하고.. 샴슈도 리암 보컬 노래중 손가락에 꼽는 최애곡인데 너무너무 예빛님 스타일로 잘 살리신 거 같아요... 악기도 통기타 하나에, 저 노래 안들어도 머릿속에 흐르는 그 배타고 강물을 거니는 소리(?)도 없는데 노래가 너무 담백하고 좋네요.... 원곡보다 좋다고 느낀 샴슈 커버 처음이에요!!! 노래해줘서 너무 고맙고 응원해요 :)"
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
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
        stackView.addArrangedSubview(divideView())
        stackView.addArrangedSubview(recordView)
    }
    
    private func initLayout(){
        setNavigationBar()
        addViews()
        
        view.backgroundColor = CommonUIAsset.begie.color
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.lessThanOrEqualToSuperview().priority(.low)
        }
    }
    
    private func divideView() -> UIView {
        let view = UIView().then {
            $0.backgroundColor = CommonUIAsset.begie.color
        }
        
        view.snp.makeConstraints {
            $0.height.equalTo(18)
        }
        
        return view
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
