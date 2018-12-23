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
    let heatingModeChanger = HeatingModeChangerFactory.create()
    private var model : HomeViewData?
    
    var lastModelUpdate : Date?
    
    let backgroundHomeViewProvider = SauceApiBackgroundHomeViewProvider()
    
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activate()
            }
        }
    }
    
    override init() {
        print("delegate init")
    }
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        print("delegate didFinishLaunching")
        
        if WCSession.isSupported() {
            session = WCSession.default
        }
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("delegate didBecomeActive")
        
        updateModel() { model in
            self.updateInterface()
        }
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
                performBackgroundUpdate()
                scheduleBackgroundRefresh()
                backgroundTask.setTaskCompleted()
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                print("watch WKSnapshotRefreshBackgroundTask")
                updateInterface()
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: .distantFuture, userInfo: nil)
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
            updateModel() { model in
                self.updateInterface()
            }
        } else {
            print("didReceiveApplicationContext with no token, removing")
            UserDefaultsTokenStore().remove()
            model = nil
            updateInterface()
            updateComplications()
        }
    }
    
    func getModel() -> HomeViewData? {
        return model
    }
    
    func updateModel(onComplete: @escaping (HomeViewData?) -> Void) {
        print("update model")
        if(authManager.isSignedIn()) {
            print("signed in, making request")
            HomeViewDataProviderFactory.create().getHomeViewData() { homeViewData in
                print("received model")
                
                self.lastModelUpdate = Date()
                
                self.model = homeViewData
                self.updateComplications()
                
                self.scheduleBackgroundRefresh()
                
                onComplete(self.model)
            }
        }
    }
    
    func updateInterface() {
        print("update interface")
        if let interface = WKExtension.shared().rootInterfaceController as! InterfaceController? {
            interface.updateDisplay(model: model)
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
    
    func setHeatingMode(_ mode: HeatingMode) {
        print("set heating mode" + mode.description)
        if(authManager.isSignedIn()) {
            heatingModeChanger.setHeatingMode(mode: mode, onSuccess: { (programme) in
                print("mode set")
                guard let model = self.model else {
                    return
                }
                self.model = HomeViewData(
                    temperature: model.temperature,
                    programme: programme,
                    callingForHeat: model.callingForHeat)
                self.updateInterface()
                self.updateComplications()
            }) {
                print("error setting heating mode")
            }
        }
    }
    
    func scheduleBackgroundRefresh() {
        let updateInterval : TimeInterval = 30 * 60
        let updateDate = lastModelUpdate?.addingTimeInterval(updateInterval) ?? Date().addingTimeInterval(updateInterval)
        print("schedule background refresh for \(updateDate)")
        WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: updateDate, userInfo: nil) { error in
        }
    }
    
    func scheduleSnapshotUpdate() {
        WKExtension.shared().scheduleSnapshotRefresh(withPreferredDate: Date(), userInfo: nil) { error in
        }
    }
    
    func performBackgroundUpdate() {
        print("perform background update")
        
        backgroundHomeViewProvider.getHomeViewData { homeViewData in
            self.model = homeViewData
            self.updateInterface()
            self.scheduleSnapshotUpdate()
            self.updateComplications()
            
        }
    }
}
