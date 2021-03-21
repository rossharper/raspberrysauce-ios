//
//  SauceApiSettingsRepository.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 21/03/2021.
//  Copyright © 2021 rossharper.net. All rights reserved.
//

import Foundation
import Combine

class SauceApiSettingsRepository {
    
    private let networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
    }
    
}

extension SauceApiSettingsRepository: SettingsRepository {
    func loadSettings() -> AnyPublisher<SettingsViewData, SettingsError> {
        return networking.get(URL(string: SauceApiEndpoints.Views.Settings)!)
            .decode(type: SettingsViewData.self, decoder: JSONDecoder())
            .mapError {
                SettingsError(error: $0)
            }
            .eraseToAnyPublisher()
    }
    
    func updateDefaultComfortTemperature(_ temperature: Temperature) -> AnyPublisher<Temperature, SettingsError> {
        return networking.post(URL(string: SauceApiEndpoints.setPointEndpoint)!, headers: ["Content-Type": "text/plain"], body: temperature.description)
            .decode(type: DefaultComfortTemperatureResponse.self, decoder: JSONDecoder())
            .mapError {
                SettingsError(error: $0)
            }
            .map {
                $0.comfortSetPoint
            }
            .eraseToAnyPublisher()
    }
    
    struct DefaultComfortTemperatureResponse: Decodable {
        let comfortSetPoint: Temperature
    }
}
