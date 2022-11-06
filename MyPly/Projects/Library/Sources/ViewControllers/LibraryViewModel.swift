//
//  LibraryViewModel.swift
//  Library
//
//  Created by choidam on 2022/08/18.
//  Copyright © 2022 cocaine.io. All rights reserved.
//

import Model

open class LibraryViewModel {
    
    let useCase = LibraryMemoUsecase()
    
    var memos = CurrentValueSubject<[Memo], Never>([])
    
    var refresh = PassthroughSubject<Void, Never>()
    var fetch = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        refresh
            .sink(receiveValue: { [weak self] in
                guard let self = self else { return }
                self.memos.send([])
                self.fetch.send(())
            })
            .store(in: &cancellables)
        
        fetch
            .throttle(for: 1, scheduler: DispatchQueue.main, latest: false)
            .sink(receiveValue: { [weak self] in
                guard let self = self else { return }
                self.useCase.loadLibraryList()
                    .sink(receiveCompletion: { [weak self] completion in
                        guard case let .failure(error) = completion else { return }
                        self?.memos.send([])
                        print(error)
                    }, receiveValue: { [weak self] memos in
                        guard let self = self else { return }
                        self.memos.send(memos)
                    })
                    .store(in: &self.cancellables)
            })
            .store(in: &cancellables)
    }
}
