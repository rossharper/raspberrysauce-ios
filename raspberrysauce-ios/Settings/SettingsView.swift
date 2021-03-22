//
//  SettingsView.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 20/03/2021.
//  Copyright © 2021 rossharper.net. All rights reserved.
//

import SwiftUI
import Combine

struct SettingsView: View {
    
    @ObservedObject private var viewModel: SettingsViewModel
    
    init(_ settingsViewModel: SettingsViewModel) {
        self.viewModel = settingsViewModel
    }
    
    var body: some View {
        createView()
            .onAppear() {
                viewModel.load()
            }
    }
    
    func createView() -> some View {
        let viewState = viewModel.viewState
        
        switch viewState {
        case .Loading:
            return AnyView(LoadingView())
        case .Error:
            return AnyView(ErrorView(retry: {
                viewModel.load()
            }))
        case let .Loaded(data):
            return AnyView(VStack() {
                TemperatureValueStepper(
                    value: data.defaultComfortTemperature,
                    onChanged: { temperature in
                        viewModel.onDefaultComfortTemperatureChanged( temperature)
                    }
                )
                Spacer()
                Button("Sign Out"){
                    viewModel.signOut()
                }
            }.padding())
        }
    }
}

fileprivate class FakeRepo : SettingsRepository {
    func loadSettings() -> AnyPublisher<SettingsViewData, SettingsError> {
        return Just(SettingsViewData(defaultComfortTemperature: Temperature(value: 20.0)))
            .setFailureType(to: SettingsError.self)
            .eraseToAnyPublisher()
    }
    func updateDefaultComfortTemperature(_ temperature: Temperature) -> AnyPublisher<Temperature, SettingsError> {
        return Empty().setFailureType(to: SettingsError.self).eraseToAnyPublisher()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SettingsViewModel(settingsRepository: FakeRepo())
        viewModel.viewState = SettingsViewModel.ViewState.Loaded(SettingsViewData(defaultComfortTemperature: Temperature(value: 20.0)))
        let settingsView = SettingsView(viewModel)
        return settingsView.accentColor(.raspberry)
    }
}
