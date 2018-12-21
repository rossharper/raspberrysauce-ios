//
//  SetPointChangerFactory.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 21/12/2018.
//  Copyright © 2018 rossharper.net. All rights reserved.
//

import Foundation

class SetPointChangerFactory {
    static func create() -> SetPointChanger {
        return SauceApiSetPointChanger(config: SauceApiSetPointChanger.Config(endpoint: URL(string:SauceApiEndpoints.setPointEndpoint)!), networking: NetworkingFactory.createAuthentiatedNetworking())
    }
}
