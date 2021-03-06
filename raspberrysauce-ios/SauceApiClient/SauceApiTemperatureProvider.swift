//
//  SauceApiTemperatureProvider.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 20/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation

class SauceApiTemperatureProvider : TemperatureProvider {
    
    let networking : Networking
    let config : Config
    
    struct Config {
        let endpoint : URL
    }
    
    init(config: Config, networking: Networking) {
        self.config = config
        self.networking = networking
    }
    
    func getTemperature(onTemperatureReceived: @escaping (_ temperature : Temperature) -> Void) {
        networking.get(url: config.endpoint, onSuccess: { value in
            guard let parsedTemperature = self.parse(value) else {
                return
            }
            onTemperatureReceived(Temperature(value: parsedTemperature))
        }) { _ in 
            // TODO: do something on error
        }
    }
    
    private func parse(_ body: Data) -> Double? {
        if let deviceTemperature = ((try? JSONSerialization.jsonObject(with: body, options: .allowFragments) as? [String: Any]) as [String : Any]??),
            let temperature = deviceTemperature?["temperature"] as? Double {
                return Double(temperature)
        }
        return nil
    }
}
