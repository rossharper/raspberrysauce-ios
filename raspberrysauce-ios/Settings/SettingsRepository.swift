//
//  SettingsRepository.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 21/03/2021.
//  Copyright © 2021 rossharper.net. All rights reserved.
//

import Foundation
import Combine

protocol SettingsRepository {
    func loadSettings() -> AnyPublisher<SettingsViewData, SettingsError>
    func updateDefaultComfortTemperature(_ temperature: Temperature) -> AnyPublisher<Temperature, SettingsError>
}

struct SettingsError: Error {
    let error: Error
}

struct SettingsViewData: Codable {
    let defaultComfortTemperature: Temperature
}

