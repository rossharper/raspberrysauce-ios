//
//  HeatingMode.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 28/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation

enum HeatingMode: String, Equatable, CaseIterable, Codable {
    case Auto = "Auto"
    case Comfort = "Comfort"
    case Setback = "Setback"
    case Off = "Off"
}
