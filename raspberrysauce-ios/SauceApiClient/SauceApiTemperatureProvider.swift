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
            guard let parsedTemperature = self.parse(body: value) else {
                return
            }
            onTemperatureReceived(Temperature(value: parsedTemperature))
        }) { 
            // TODO: do something on error
        }
    }
    
    private func parse(body: Data) -> Float? {
        if let deviceTemperature = try? JSONSerialization.jsonObject(with: body, options: .allowFragments) as? [String: Any],
            let temperature = deviceTemperature?["temperature"] as? Float {
                return Float(temperature)
        }
        return nil
    }
}
