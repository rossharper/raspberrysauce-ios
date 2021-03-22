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
        load()
    }
    
    func load() {
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

protocol HomeViewRepository {
    func load() -> AnyPublisher<HomeViewDataV2, Error>
}

class SauceApiHomeViewRepository: HomeViewRepository {
    func load() -> AnyPublisher<HomeViewDataV2, Error> {
        return Just(HomeViewDataV2()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}

struct HomeViewDataV2 {}
