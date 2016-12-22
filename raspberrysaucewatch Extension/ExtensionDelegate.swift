//
//  ExtensionDelegate.swift
//  raspberrysaucewatch Extension
//
//  Created by Ross Harper on 20/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {

    let authManager = AuthManagerFactory.create()
    private var model : Model?
    
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activate()
            }
        }
    }
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        print("watch didFinishLaunching")
        
        if WCSession.isSupported() {
            session = WCSession.default()
        }
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("watch didBecomeActive")
        
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                print("watch WKApplicationRefreshBackgroundTask")
                backgroundTask.setTaskCompleted()
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                print("watch WKSnapshotRefreshBackgroundTask")
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                print("watch WKWatchConnectivityRefreshBackgroundTask")
                connectivityTask.setTaskCompleted()
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                print("watch WKURLSessionRefreshBackgroundTask")
                urlSessionTask.setTaskCompleted()
            default:
                // make sure to complete unhandled task types
                task.setTaskCompleted()
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        let tokenValue = applicationContext["token"] as! String?
        if tokenValue != nil {
            print("didReceiveApplicationContext with token")
            UserDefaultsTokenStore().put(token: Token(value: tokenValue!))
        } else {
            print("didReceiveApplicationContext with no token, removing")
            UserDefaultsTokenStore().remove()
        }
    }
    
    func getModel() -> Model? {
        return model
    }
    
    func updateModel(onComplete: @escaping (Model?) -> Void) {
        print("update model")
        if(authManager.isSignedIn()) {
            print("signed in, making request")
            TemperatureProviderFactory.create().getTemperature { temperature in
                print("received temperature")  
                
                self.model = Model(temperature: temperature)
                onComplete(self.model)
                
                self.updateComplications()
            }
        }
    }
    
    func updateComplications() {
        let complicationServer = CLKComplicationServer.sharedInstance()
        let complications = complicationServer.activeComplications
        if(complications != nil) {
            for complication in complications! {
                CLKComplicationServer.sharedInstance().reloadTimeline(for: complication)
            }
        }
    }
}
