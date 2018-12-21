//
//  SauceApiSetPointChanger.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 21/12/2018.
//  Copyright © 2018 rossharper.net. All rights reserved.
//

import Foundation

struct ApiComfortSetPointResponse : Decodable {
    let comfortSetPoint : Double
}

class SauceApiSetPointChanger : SetPointChanger {
    let networking : Networking
    let config : Config
    
    struct Config {
        let endpoint : URL
    }
    
    init(config: Config, networking: Networking) {
        self.config = config
        self.networking = networking
    }
    
    func setComfortSetPoint(temperature: Temperature, onSuccess: @escaping (Temperature) -> Void, onError: @escaping () -> Void) {
        networking.post(url: config.endpoint, headers: ["Content-Type": "text/plain"], body: temperature.description, onSuccess: { (data) in
            guard let temperature = self.parse(data) else {
                onError()
                return
            }
            onSuccess(temperature)
        }) { _ in
            onError()
        }
    }
    
    func parse(_ body: Data) -> Temperature? {
        guard let response = try? JSONDecoder().decode(ApiComfortSetPointResponse.self, from: body) else {
            return nil
        }
        return Temperature(value: response.comfortSetPoint)
    }
}
