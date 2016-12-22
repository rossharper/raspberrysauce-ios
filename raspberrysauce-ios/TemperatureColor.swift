//
//  TemperatureColor.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 22/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation
import UIKit

struct TemperatureColor {
    static func colorForTemperature(_ temperature: Temperature) -> UIColor {
        let color : UIColor
        switch(temperature.value) {
        case 25..<100:
            color = UIColor(red: 1, green: 0.329, blue: 0.133, alpha: 1)
        case 22..<25:
            color = UIColor(red: 1, green: 0.439, blue: 0, alpha: 1)
        case 19..<22:
            color = UIColor(red: 1, green: 0.608, blue: 0.145, alpha: 1)
        case 16..<19:
            color = UIColor(red: 1, green: 0.831, blue: 0.396, alpha: 1)
        case 13..<16:
            color = UIColor(red: 1, green: 0.953, blue: 0.341, alpha: 1)
        case 10..<13:
            color = UIColor(red: 0.765, green: 1, blue: 0.365, alpha: 1)
        case 1..<10:
            color = UIColor(red: 0.412, green: 0.765, blue: 1, alpha: 1)
        default:
            color = UIColor(red: 0.612, green: 0.851, blue: 1, alpha: 1)
        }
        return color
    }
}
