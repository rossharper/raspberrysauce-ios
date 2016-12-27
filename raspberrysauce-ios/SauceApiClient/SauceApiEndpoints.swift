//
//  SauceApiEndpoints.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 27/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation

struct SauceApiEndpoints {
    static let accessTokenEndpoint = "\(AppConfig.ApiBaseUrl)/requestAppToken"
    static let homeViewEndpoint = "\(AppConfig.ApiBaseUrl)/api/views/ios/home"
    static let temperatureEndpoint = "\(AppConfig.ApiBaseUrl)/api/temperature"
    static let setModeEndpoint = "\(AppConfig.ApiBaseUrl)/api/programme/setMode/"
}
