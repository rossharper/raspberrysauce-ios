//
//  HomeViewDataProviderFactory.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 22/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation

class HomeViewDataProviderFactory {
    static func create() -> HomeViewDataProvider {
        return SauceApiHomeViewDataProvider(config: SauceApiHomeViewDataProvider.Config(endpoint: URL(string:SauceApiEndpoints.homeViewEndpoint)!), networking: NetworkingFactory.createAuthentiatedNetworking())
    }
}
