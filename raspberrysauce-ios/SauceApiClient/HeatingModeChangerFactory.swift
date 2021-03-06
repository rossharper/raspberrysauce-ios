//
//  HeatingModeChangerFactory.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 22/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation

class HeatingModeChangerFactory {
    static func create() -> HeatingModeChanger {
        return SauceApiHeatingModeChanger(config: SauceApiHeatingModeChanger.Config(endpoint: URL(string:SauceApiEndpoints.setModeEndpoint)!), networking: NetworkingFactory.createAuthentiatedNetworking())
    }
}
