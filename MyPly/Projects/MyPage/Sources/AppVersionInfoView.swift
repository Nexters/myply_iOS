//
//  File.swift
//  MyPage
//
//  Created by nylah.j on 2022/08/13.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import UIKit

class AppVersionInfoView: UIView {
    let label: UILabel = {
        $0.text = "앱 버전"
        return $0
    }(UILabel())
    
    let versionLabel: UILabel = {
        return $0
    }(UILabel())
    
    init() {
        super.init(frame: .zero)
        self.addSubview(label)
        self.addSubview(versionLabel)
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(20)
            make.center.equalToSuperview()
        }
        
        versionLabel.snp.makeConstraints { make in
            make.leading.equalTo(label.snp.trailing)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(label.snp.centerY)
        }
        versionLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        self.snp.makeConstraints { make in
            make.height.equalTo(label).offset(28)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setVersion(_ versionNumber: CGFloat) {
        versionLabel.text = String("\(versionNumber)")
    }
}
