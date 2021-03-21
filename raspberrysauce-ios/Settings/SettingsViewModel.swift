//
//  SettingsViewModel.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 20/03/2021.
//  Copyright © 2021 rossharper.net. All rights reserved.
//

import SwiftUI
import Combine

class SettingsViewModel: ObservableObject, Identifiable {

    @Published var viewState: ViewState = .Loading
    
    private let settingsRepository: SettingsRepository
    
    private let inputSubject = PassthroughSubject<Temperature, Never>()

    private var disposables = Set<AnyCancellable>()
    
    init(settingsRepository: SettingsRepository) {
        self.settingsRepository = settingsRepository
        
        inputSubject
            .debounce(for: .seconds(1.0), scheduler: RunLoop.main)
            .sink { temperature in
                self.updateDefaultComfortTemperature(temperature)
            }
            .store(in: &disposables)
        
        load()
    }
    
    func load() {
        self.viewState = .Loading
        settingsRepository.loadSettings()
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
    
    func onDefaultComfortTemperatureChanged(_ temperature: Temperature) {
        inputSubject.send(temperature)
    }

    func signOut() {
        AuthManagerFactory.create().signOut()
    }
    
    private func updateDefaultComfortTemperature(_ temperature: Temperature) {
        settingsRepository.updateDefaultComfortTemperature(temperature)
            .receive(on: DispatchQueue.main)
            .mapError( { error -> Error in
                print(error)
                self.viewState = ViewState.Error
                return error
            })
            .sink(receiveCompletion: { _ in },
                  receiveValue: { newTemperature in
                    self.viewState = .Loaded(SettingsViewData(defaultComfortTemperature: newTemperature))
            })
            .store(in: &disposables)
    }
    
    enum ViewState {
        case Loading, Loaded(SettingsViewData), Error
    }
}
