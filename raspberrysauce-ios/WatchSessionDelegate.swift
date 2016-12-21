//
//  WatchSessionDelegate.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 21/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchSessionDelegate : NSObject, WCSessionDelegate {
    
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activate()
            }
        }
    }
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            session = WCSession.default()
        }
        // register to listen to auth events and update watch appropriately
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // TODO: handle session switching properly
    }
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    func sessionDidDeactivate(_ session: WCSession) {
    }
    
    // HACK: temporary way of transferring data - investigate better methods
    /*
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if (message["loadTemperature"] as? String) != nil {
            TemperatureProviderFactory.create().getTemperature(onTemperatureReceived: { temperature in
                replyHandler(["temperature" : TemperatureFormatter.asString(temperature: temperature) as AnyObject])
            })
        }
    }*/
}
