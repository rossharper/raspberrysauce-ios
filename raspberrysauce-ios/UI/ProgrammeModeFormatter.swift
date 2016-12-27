//
//  ProgrammeModeFormatter.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 22/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation

struct ProgrammeModeFormatter {
    static func asString(programme: Programme) -> String {
        if(programme.heatingEnabled) {
            return (programme.comfortLevelEnabled) ? "COMFORT" : "ECONOMY"
        } else {
            return "OFF"
        }
    }
}
