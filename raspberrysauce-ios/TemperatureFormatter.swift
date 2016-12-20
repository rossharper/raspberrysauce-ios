//
//  TemperatureFormatter.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 20/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation

struct TemperatureFormatter {
    static func asString(temperature: Temperature) -> String {
        return String(format: "%.1fºC", temperature.value)
    }
}
