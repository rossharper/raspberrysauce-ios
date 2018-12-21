//
//  SauceApiBackgroundTemperatureProvider.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 27/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation

// TODO: such duplication. wow.

class SauceApiBackgroundHomeViewProvider : NSObject, HomeViewDataProvider, URLSessionDownloadDelegate {
    
    let authManager = AuthManagerFactory.create()
    var onReceived : ((HomeViewData) -> Void)?
    
    func getHomeViewData(onReceived: @escaping (_ homeViewData : HomeViewData) -> Void) {
        print("getHomeViewData in background")
        
        self.onReceived = onReceived
        
        if let token = authManager.getAccessToken() {
            let backgroundConfigObject = URLSessionConfiguration.background(withIdentifier: "FUCKTHISSHIT")
            backgroundConfigObject.sessionSendsLaunchEvents = true
            let backgroundSession = URLSession(configuration: backgroundConfigObject, delegate: self, delegateQueue:nil)
            
            var request = URLRequest(url: URL(string: SauceApiEndpoints.homeViewEndpoint)!)
            request.httpMethod = "GET"
            request.addValue("Bearer \(token.value)", forHTTPHeaderField: "Authorization")
            let downloadTask = backgroundSession.downloadTask(with: request)
            downloadTask.resume()
        }
    }
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print("didBecomeInvalidWithError \(String(describing: error))")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("didCompelteWithError \(String(describing: error))")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("NSURLSession finished to url: ", location)
        
        if let data = try? Data(contentsOf: location),
            let homeViewData = parse(data) {
            self.onReceived?(homeViewData)
        }
    }
    
    private func parse(_ body: Data) -> HomeViewData? {
        guard let apiHomeViewData = try? JSONDecoder().decode(ApiHomeViewData.self, from: body) else {
            return nil
        }
        
        let periods = apiHomeViewData.programme.todaysPeriods.map {
            apiPeriod in
            return ProgrammePeriod(isComfort: apiPeriod.isComfort, startTime: apiPeriod.startTime, endTime: apiPeriod.endTime)
        }
        
        let programme = Programme(heatingEnabled: apiHomeViewData.programme.heatingEnabled, comfortLevelEnabled: apiHomeViewData.programme.comfortLevelEnabled, inOverride: apiHomeViewData.programme.inOverride, periods: periods, comfortSetPoint: apiHomeViewData.programme.comfortSetPoint)
        
        let homeData = HomeViewData(temperature: Temperature(value: apiHomeViewData.temperature), programme: programme)
        
        return homeData
    }
}
