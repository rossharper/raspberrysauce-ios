//
//  HomeView.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 22/03/2021.
//  Copyright © 2021 rossharper.net. All rights reserved.
//

import SwiftUI
import Combine

struct HomeView: View {
    
    @ObservedObject private var viewModel: HomeViewModel
    
    init(_ viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        let viewState = viewModel.viewState
        
        switch viewState {
        case .Loading:
            LoadingView()
        case .Error:
            ErrorView(retry: {
                viewModel.load()
            })
        case let .Loaded(data):
            VStack() {
                HeatingModePicker(heatingMode: data.heatingMode, onChange: viewModel.onModeChanged)
                Spacer()
            }
            .padding()
        }
    }
}

fileprivate class FakeRepo: HomeViewRepository {
    func load() -> AnyPublisher<HomeViewDataV2, SauceApiError> {
        return Just(HomeViewDataV2(heatingMode: .Auto))
            .setFailureType(to: SauceApiError.self)
            .eraseToAnyPublisher()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = HomeViewModel(repo: FakeRepo())
        viewModel.viewState = HomeViewModel.ViewState.Loaded(HomeViewDataV2(heatingMode: HeatingMode.Auto))
        return HomeView(viewModel)
    }
}
