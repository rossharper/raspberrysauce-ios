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
            guard let homeViewData = self.parse(value) else {
                print ("failed to parse")
                return
            }
            onReceived(homeViewData)
        }) {
            print("error loading request")
            // TODO: something on error
        }
    }
    
    func parse(_ body: Data) -> HomeViewData? {
        guard let homeViewData = try? JSONSerialization.jsonObject(with: body, options: .allowFragments) as! [String: Any],
                    let temperature = homeViewData["temperature"] as? Float,
                    let programmeData = homeViewData["programme"] as? [String : Any],
                    let programme = ProgrammeParser().parse(programmeData) else {
                return nil
        }
        return HomeViewData(temperature: Temperature(value: Float(temperature)), programme: programme)
    }
    

}
