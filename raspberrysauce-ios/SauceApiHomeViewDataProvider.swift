//
//  SauceApiHomeViewDataProvider.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 22/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation

class SauceApiHomeViewDataProvider : HomeViewDataProvider {
    let networking : Networking
    let config : Config

    struct Config {
        let endpoint : URL
    }

    init(config: Config, networking: Networking) {
        self.config = config
        self.networking = networking
    }
    
    func getHomeViewData(onReceived: @escaping (_ homeViewData : HomeViewData) -> Void) {
        networking.get(url: config.endpoint, onSuccess: { value in
            guard let homeViewData = self.parse(body: value) else {
                return
            }
            onReceived(homeViewData)
        }) {
            print("error loading request")
            // TODO: something on error
        }
    }
    
    func parse(body: Data) -> HomeViewData? {
        if let homeViewData = try? JSONSerialization.jsonObject(with: body, options: .allowFragments) as? [String: Any],
            let temperature = homeViewData?["temperature"] as? Float {
            return HomeViewData(temperature: Temperature(value: Float(temperature)))
        }
        return nil
    }
}
