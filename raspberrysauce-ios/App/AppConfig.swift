//
//  AppConfig.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 20/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation

struct AppConfig {
    static var ApiBaseUrl : String {
        get {
            guard let rawValue = getenv("API_BASE_URL") else { return "" }
            let baseUrl = String(utf8String: rawValue)
            return baseUrl ?? ""
        }
    }
}

