//
//  TemperatureProvider.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 20/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation

protocol TemperatureProvider {
    func getTemperature(onTemperatureReceived: @escaping (_ temperature : Temperature) -> Void)
}
