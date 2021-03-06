//
//  ProgrammeModeFormatter.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 22/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation

struct ProgrammeModeFormatter {
    
    static let comfortText = "COMFORT"
    static let setbackText = "ECONOMY"
    static let offText = "OFF"
    static let autoEmoji = "🕒"
    static let comfortEmoji = "☀️"
    static let setbackEmoji = "🌙"
    static let offEmoji = "🚫"
    
    static func asString(_ programme: Programme) -> String {
        if(programme.heatingEnabled) {
            return (programme.comfortLevelEnabled) ? comfortText : setbackText
        } else {
            return offText
        }
    }
    
    static func asEmoji(_ programme: Programme) -> String {
        switch(programme.heatingEnabled, programme.comfortLevelEnabled, programme.inOverride) {
        case(true, true, true):
            return "\(comfortEmoji)"
        case (true, false, true):
            return "\(setbackEmoji)"
        case (true, true, false):
            return "\(autoEmoji) \(comfortEmoji)"
        case (true, false, false):
            return "\(autoEmoji) \(setbackEmoji)"
        default:
            return "\(offEmoji)"
        }
    }
    
    static func asStringWithEmoji(_ programme: Programme) -> String {
        return "\(asEmoji(programme)) \(asString(programme))"
    }
}
