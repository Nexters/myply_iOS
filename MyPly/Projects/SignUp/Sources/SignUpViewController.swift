//
//  SignUpViewController.swift
//  SignUp
//
//  Created by 최모지 on 2022/08/13.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit
import CommonUI

open class SignUpViewController: UIViewController {
    
    // MARK: UI
    
    private let nickNameLabel = UILabel().then {
        $0.text = "닉네임을 입력해 주세요."
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.textColor = CommonUIAsset.gray80.color
    }
    
    private let descLabel = UILabel().then {
        $0.text = "닉네임은 언제든지 바꿀 수 있어요."
        $0.font = .systemFont(ofSize: 14, weight: .bold)
        $0.textColor = CommonUIAsset.gray50.color // 변경하기
    }
    
    private let textFieldView = UIView().then {
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 2
        $0.layer.borderColor = CommonUIAsset.gray50.color.cgColor // 변경하기
    }
    
    private let textField = UITextField().then {
        $0.placeholder = "한글 혹은 영어 8자"
        $0.borderStyle = .none
    }
    
    private let countLabel = UILabel().then {
        $0.text = "0/8"
        $0.font = .systemFont(ofSize: 14)
        $0.textAlignment = .right
        $0.textColor = CommonUIAsset.gray50.color
    }
    
    private let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.textColor = .white
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        $0.backgroundColor = .systemGreen // 변경하기
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        initLayout()
        
        bindState()
        bindAction()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
}

extension SignUpViewController {
    private func addViews(){
        view.addSubview(nickNameLabel)
        view.addSubview(descLabel)
        view.addSubview(textFieldView)
        textFieldView.addSubview(textField)
        view.addSubview(countLabel)
        view.addSubview(nextButton)
    }
    
    private func initLayout(){
        addViews()
        
        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
        }
        
        descLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(8)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
        }
        
        textFieldView.snp.makeConstraints {
            $0.top.equalTo(descLabel.snp.bottom).offset(32)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(56)
        }
        
        textField.snp.makeConstraints {
            $0.top.leading.equalTo(16)
            $0.bottom.trailing.equalTo(-16)
        }
        
        countLabel.snp.makeConstraints {
            $0.top.equalTo(textFieldView.snp.bottom).offset(4)
            $0.trailing.equalTo(-20)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(56)
            $0.bottom.equalTo(-56)
        }
    }
    
    @objc func keyboardWillAppear(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            
            nextButton.snp.updateConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(56)
                $0.bottom.equalTo(-keyboardHeight)
            }
        }
    }

    @objc func keyboardWillDisappear() {
        nextButton.snp.updateConstraints {
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(56)
            $0.bottom.equalTo(-56)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension SignUpViewController {
    private func bindState(){
        
    }
    
    private func bindAction(){
        
    }
}
