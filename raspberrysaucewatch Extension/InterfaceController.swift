//
//  InterfaceController.swift
//  raspberrysaucewatch Extension
//
//  Created by Ross Harper on 20/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var label: WKInterfaceLabel!
    
    //let tokenStore = TokenStore
    
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activate()
            }
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        self.updateDisplay()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    private func updateDisplay() {
    }

    /*
    private func loadTemperature() {
        if WCSession.isSupported() {
            session = WCSession.default()
            // HACK: probably not the correct way to try and load data
            session!.sendMessage(["loadTemperature" : "load"], replyHandler: { response in
                let temperature = response["temperature"] as? String
                // HACK: temporarily store in user defaults to get through to complication
                UserDefaults.standard.set(temperature, forKey: "currentTemperature")
                self.label.setText(temperature)
            }, errorHandler: { error in
                self.label.setText("error")
            })
        }
    }
 */

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState,
           error: Error?){
    }
}
