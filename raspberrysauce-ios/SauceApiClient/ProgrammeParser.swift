//
//  ProgrammeParser.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 22/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation

struct ProgrammeParser {
    func parse(_ data: [ String : Any ]) -> Programme? {
        guard let heatingEnabled = data["heatingEnabled"] as? Bool,
            let comfortLevelEnabled = data["comfortLevelEnabled"] as? Bool,
            let inOverride = data["inOverride"] as? Bool,
            let periodsData = data["todaysPeriods"] as? [[String : Any]] else {
                return nil
        }
        let periods = parsePeriods(periodsData)
        return Programme(heatingEnabled: heatingEnabled, comfortLevelEnabled: comfortLevelEnabled, inOverride: inOverride, periods: periods)
    }
    
    private func parsePeriods(_ data: [[String : Any]]) -> [ProgrammePeriod] {
        var periods : [ProgrammePeriod] = []

        for periodData in data {
            if let isComfort = periodData["isComfort"] as? Bool,
                let startTime = periodData["startTime"] as? String,
                let endTime = periodData["endTime"] as? String {
                periods.append(ProgrammePeriod(isComfort: isComfort, startTime: startTime, endTime: endTime))
            }
        }
        return periods
    }
}
