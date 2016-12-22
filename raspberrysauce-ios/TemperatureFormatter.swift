//
//  TemperatureFormatter.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 20/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation

struct TemperatureFormatter {
    static func asString(_ temperature: Temperature) -> String {
        return "\(valueAsString(temperature))\(unitAsString(temperature))"
    }
    
    static func valueAsString(_ temperature: Temperature) -> String {
        return String(format: "%.1f", temperature.value)
    }
    
    static func unitAsString(_ temperature: Temperature) -> String {
        return "ºC"
    }
}
