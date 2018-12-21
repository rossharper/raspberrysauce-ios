//
//  SauceApiHeatingModeChanger.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 22/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation

extension HeatingMode : CustomStringConvertible {
    var description: String {
        switch self {
        case .Auto: return "auto"
        case .Comfort: return "comfort"
        case .Setback: return "setback"
        case .Off: return "heatingOff"
        }
    }
}

class SauceApiHeatingModeChanger : HeatingModeChanger {
    let networking : Networking
    let config : Config
    
    struct Config {
        let endpoint : URL
    }
    
    init(config: Config, networking: Networking) {
        self.config = config
        self.networking = networking
    }
    
    func setHeatingMode(mode: HeatingMode, onSuccess: @escaping (Programme) -> Void, onError: @escaping () -> Void) {
        let url = buildUrl(mode)
        networking.post(url: url, body: "", onSuccess: { (data) in
            guard let programme = self.parse(data) else {
                onError()
                return
            }
            onSuccess(programme)
        }) { _ in 
            onError()
        }
    }
    
    func buildUrl(_ mode: HeatingMode) -> URL {
        return config.endpoint.appendingPathComponent(mode.description)
    }
    
    func parse(_ body: Data) -> Programme? {
        return ProgrammeParser().parse(body)
    }
}
