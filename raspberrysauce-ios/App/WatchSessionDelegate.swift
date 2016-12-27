//
//  WatchSessionDelegate.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 21/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchSessionDelegate : NSObject, WCSessionDelegate, AuthObserver {
    
    let authManager = AuthManagerFactory.create()
    
    var session: WCSession?
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            session = WCSession.default()
            if session != nil {
                session!.delegate = self
                session!.activate()
            }
        }
        authManager.setAuthObserver(observer: self)
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // TODO: handle session switching properly
        print("iOS App Session Did activate")
        if(authManager.isSignedIn()) {
            sendToken(token: authManager.getAccessToken())
        }
        else {
            sendSignedOut()
        }
    }
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("iOS App Session Did become inactive")
    }
    func sessionDidDeactivate(_ session: WCSession) {
        print("iOS App Session Did deactivate")
    }
    
    func onSignedIn() {
        sendToken(token: authManager.getAccessToken())
    }
    
    func onSignedOut() {
        sendSignedOut()
    }
    
    func onSignInFailed() {
    }
    
    func sendToken(token: Token?) {
        print("send token...")
        guard let token = authManager.getAccessToken() else { return }
        guard let session = self.session else { return }
        print("sending")
        try? session.updateApplicationContext(["token" : token.value])
    }
    
    func sendSignedOut() {
        print("send signed out")
        guard let session = self.session else { return }
        print("sending")
        try? session.updateApplicationContext([:])
    }
}
