//
//  ProgrammeModeColor.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 22/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation
import UIKit

struct ProgrammeModeColor {
    static let autoColor = UIColor(red: 0.596, green: 0.929, blue: 0.525, alpha: 1)
static let comfortColor = UIColor(red: 1, green: 0.608, blue: 0.145, alpha: 1)
    static let setbackColor = UIColor(red: 0.529, green: 0.875, blue: 1, alpha: 1)
    static let offColor = UIColor(red: 0.757, green: 0.0824, blue: 0.247, alpha: 1)
    
    static func colorForMode(_ programme: Programme) -> UIColor {
        if(programme.heatingEnabled) {
            return (programme.comfortLevelEnabled) ? comfortColor : setbackColor
        } else {
            return offColor
        }
    }
}
