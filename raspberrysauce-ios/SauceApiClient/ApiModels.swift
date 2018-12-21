//
//  ApiModels.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 21/12/2018.
//  Copyright © 2018 rossharper.net. All rights reserved.
//

import Foundation

struct ApiPeriod : Decodable {
    let isComfort : Bool
    let startTime : String
    let endTime : String
}

struct ApiProgramme : Decodable {
    let heatingEnabled : Bool
    let comfortLevelEnabled : Bool
    let inOverride : Bool
    let todaysPeriods : [ApiPeriod]
    let comfortSetPoint : Double
}
