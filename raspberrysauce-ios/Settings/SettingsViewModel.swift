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
    
    private let settingsFetcher: SettingsFetchable

    private var task: AnyCancellable?
    
    init(settingsFetcher: SettingsFetchable) {
        self.settingsFetcher = settingsFetcher
        load()
    }
    
    func load() {
        self.viewState = .Loading
        task = settingsFetcher.loadSettings()
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
    }
    
    func signOut() {
        AuthManagerFactory.create().signOut()
    }
    
    enum ViewState {
        case Loading, Loaded(SettingsViewData), Error
    }
}

protocol SettingsFetchable {
    func loadSettings() -> AnyPublisher<SettingsViewData, SettingsError>
}

class SauceApiSettingsFetcher {
}

extension SauceApiSettingsFetcher: SettingsFetchable {
    func loadSettings() -> AnyPublisher<SettingsViewData, SettingsError> {        
        let authManager = AuthManagerFactory.create()
        let headers = ["Authorization": "Bearer \(authManager.getAccessToken()!.value)"]
        return get(URL(string: SauceApiEndpoints.Views.Settings)!, headers: headers)
            .decode(type: SettingsViewData.self, decoder: JSONDecoder())
            .mapError {
                SettingsError(error: $0)
            }
            .eraseToAnyPublisher()
    }
    
    func get(_ url: URL, headers: [String : String]?) -> AnyPublisher<Data, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return doRequest(&request, headers: headers)
    }
    
    func doRequest(_ request: inout URLRequest, headers: [String : String]?) -> AnyPublisher<Data, Error> {
        if let headers = headers {
            for key in headers.keys {
                request.addValue(headers[key]!, forHTTPHeaderField: key)
            }
        }
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                
                if httpResponse.statusCode != 200 {
                    if let data = String(data: element.data, encoding: String.Encoding.utf8) {
                        print(data)
                    }
                    throw URLError(.badServerResponse)
                }
                
                return element.data
            }
            .eraseToAnyPublisher()
    }
}

struct SettingsError: Error {
    let error: Error
}

struct SettingsViewData: Codable {
    let defaultComfortTemperature: Temperature
}
