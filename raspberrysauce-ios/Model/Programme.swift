//
//  Programme.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 22/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation

struct ProgrammePeriod {
    let isComfort : Bool
    let startTime : String
    let endTime : String
}

class Programme {
    let heatingEnabled : Bool
    let comfortLevelEnabled : Bool
    let inOverride : Bool
    let periods : [ProgrammePeriod]
    
    init(heatingEnabled: Bool, comfortLevelEnabled: Bool, inOverride: Bool, periods: [ProgrammePeriod]) {
        self.heatingEnabled = heatingEnabled
        self.comfortLevelEnabled = comfortLevelEnabled
        self.inOverride = inOverride
        self.periods = periods
    }
}
