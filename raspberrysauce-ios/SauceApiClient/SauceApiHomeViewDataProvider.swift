//
//  SauceApiHomeViewDataProvider.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 22/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
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
}

struct ApiHomeViewData : Decodable {
    let temperature : Float
    let programme : ApiProgramme
}

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
            guard let parsedData = self.parse(value) else {
                print ("failed to parse")
                return
            }
            onReceived(parsedData)
        }) {_ in
            print("error loading request")
            // TODO: something on error!
        }
    }
    
    func parse(_ body: Data) -> HomeViewData? {
        
        guard let apiHomeViewData = try? JSONDecoder().decode(ApiHomeViewData.self, from: body) else {
            return nil
        }

        let periods = apiHomeViewData.programme.todaysPeriods.map {
            apiPeriod in
            return ProgrammePeriod(isComfort: apiPeriod.isComfort, startTime: apiPeriod.startTime, endTime: apiPeriod.endTime)
        }
        
        let programme = Programme(heatingEnabled: apiHomeViewData.programme.heatingEnabled, comfortLevelEnabled: apiHomeViewData.programme.comfortLevelEnabled, inOverride: apiHomeViewData.programme.inOverride, periods: periods)
        
        let homeData = HomeViewData(temperature: Temperature(value: apiHomeViewData.temperature), programme: programme)
        
        return homeData
//
//        guard let homeViewData = try? JSONSerialization.jsonObject(with: body, options: .allowFragments) as! [String: Any],
//                    let temperature = homeViewData["temperature"] as? Float,
//                    let programmeData = homeViewData["programme"] as? [String : Any],
//                    let programme = ProgrammeParser().parse(programmeData) else {
//                return nil
//        }
//        return HomeViewData(temperature: Temperature(value: Float(temperature)), programme: programme)
    }
    

}
