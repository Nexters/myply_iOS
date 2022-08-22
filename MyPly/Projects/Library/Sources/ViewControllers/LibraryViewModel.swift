//
//  LibraryViewModel.swift
//  Library
//
//  Created by choidam on 2022/08/18.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Model

open class LibraryViewModel {
    
    let memos: [Memo]
    
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        self.memos = []
        
    }
}
