//
//  TemperatureProviderFactory.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 20/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation

class TemperatureProviderFactory {
    static func create() -> TemperatureProvider {
        return SauceApiTemperatureProvider(config: SauceApiTemperatureProvider.Config(endpoint: URL(string:SauceApiEndpoints.temperatureEndpoint)!), networking: NetworkingFactory.createAuthentiatedNetworking())
    }
}
