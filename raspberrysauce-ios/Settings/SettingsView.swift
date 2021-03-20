//
//  SettingsView.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 20/03/2021.
//  Copyright © 2021 rossharper.net. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var viewModel = SettingsViewModel(settingsFetcher: SauceApiSettingsFetcher())
    
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
            }.padding()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let settingsView = SettingsView()
        settingsView.viewModel.viewState = SettingsViewModel.ViewState.Loaded(SettingsViewData(defaultComfortTemperature: Temperature(value: 20.0)))
        return settingsView.accentColor(.raspberry)
    }
}
