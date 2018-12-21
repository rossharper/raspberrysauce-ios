//
//  ProgrammeParser.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 22/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation

struct ProgrammeParser {

    func parse(_ data: Data) -> Programme? {
        guard let apiProgramme = try? JSONDecoder().decode(ApiProgramme.self, from: data) else {
            return nil
        }
        
        let periods = apiProgramme.todaysPeriods.map {
            apiPeriod in
            return ProgrammePeriod(isComfort: apiPeriod.isComfort, startTime: apiPeriod.startTime, endTime: apiPeriod.endTime)
        }
        
        let programme = Programme(heatingEnabled: apiProgramme.heatingEnabled, comfortLevelEnabled: apiProgramme.comfortLevelEnabled, inOverride: apiProgramme.inOverride, periods: periods, comfortSetPoint: apiProgramme.comfortSetPoint)
        
        return programme
    }
}
