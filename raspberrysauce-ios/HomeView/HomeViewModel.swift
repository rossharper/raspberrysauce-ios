//
//  HomeViewModel.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 22/03/2021.
//  Copyright © 2021 rossharper.net. All rights reserved.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject, Identifiable {
    
    @Published var viewState: ViewState = .Loading
    
    private let repo: HomeViewRepository
    private var disposables = Set<AnyCancellable>()
    
    init(repo: HomeViewRepository) {
        self.repo = repo
    }
    
    func load() {
        self.viewState = .Loading
        repo.load()
            .receive(on: DispatchQueue.main)
            .mapError( { error -> Error in
                print(error)
                self.viewState = ViewState.Error
                return error
            })
            .sink(receiveCompletion: { _ in },
                  receiveValue: { data in
                self.viewState = ViewState.Loaded(data)
            })
            .store(in: &disposables)
    }
    
    func onModeChanged(_ heatingMode: HeatingMode) {
        
    }
        
    enum ViewState {
        case Loading, Loaded(HomeViewDataV2), Error
    }
}
