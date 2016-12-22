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
            let inOverride = data["inOverride"] as? Bool else {
                return nil
        }
        return Programme(heatingEnabled: heatingEnabled, comfortLevelEnabled: comfortLevelEnabled, inOverride: inOverride)
    }
}
