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

struct ApiHeatingModeChangedData : Decodable {
    let programme : ApiProgramme
    let callingForHeat : Bool
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
    
    func setHeatingMode(mode: HeatingMode, onSuccess: @escaping (HeatingModeChangedData) -> Void, onError: @escaping () -> Void) {
        let url = buildUrl(mode)
        networking.post(url: url, body: "", onSuccess: { (data) in
            guard let heatingModeChangedData = self.parse(data) else {
                onError()
                return
            }
            onSuccess(heatingModeChangedData)
        }) { _ in 
            onError()
        }
    }
    
    func buildUrl(_ mode: HeatingMode) -> URL {
        return config.endpoint.appendingPathComponent(mode.description)
    }
    
    func parse(_ body: Data) -> HeatingModeChangedData? {
        guard let apiHeatingModeChangedData = try? JSONDecoder().decode(ApiHeatingModeChangedData.self, from: body) else {
            return nil
        }
        
        let periods = apiHeatingModeChangedData.programme.todaysPeriods.map {
            apiPeriod in
            return ProgrammePeriod(
                isComfort: apiPeriod.isComfort,
                startTime: apiPeriod.startTime,
                endTime: apiPeriod.endTime)
        }
        
        let programme = Programme(
            heatingEnabled: apiHeatingModeChangedData.programme.heatingEnabled,
            comfortLevelEnabled: apiHeatingModeChangedData.programme.comfortLevelEnabled,
            inOverride: apiHeatingModeChangedData.programme.inOverride,
            periods: periods,
            comfortSetPoint: apiHeatingModeChangedData.programme.comfortSetPoint)
        
        let modeChangedData = HeatingModeChangedData(
            programme: programme,
            callingForHeat: apiHeatingModeChangedData.callingForHeat)
        
        return modeChangedData
    }
}
