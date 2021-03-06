//
//  InterfaceController.swift
//  raspberrysaucewatch Extension
//
//  Created by Ross Harper on 20/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {

    @IBOutlet var label: WKInterfaceLabel!
    @IBOutlet var temperatureLabel: WKInterfaceLabel!
    @IBOutlet var modeLabel: WKInterfaceLabel!
    @IBOutlet var autoLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        print("watch view awake")
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        print("watch view willActivate")
        
        let extensionDelegate = WKExtension.shared().delegate as! ExtensionDelegate
        
        if(!extensionDelegate.authManager.isSignedIn()) {
            displaySignedOut()
            return
        }
        
        self.updateDisplay(model: extensionDelegate.getModel())
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func updateDisplay(model: HomeViewData?) {
        print("update display")
        guard let model = model else {
            displayNoData()
            return
        }
        
        displayData(model: model)
    }
    
    private func displayData(model : HomeViewData) {
        addMenuItem(withImageNamed: "AutoModeMenuIcon", title: "Auto", action: #selector(onAutoSelected))
        addMenuItem(withImageNamed: "ComfortModeMenuIcon", title: "Comfort", action: #selector(onComfortSelected))
        addMenuItem(withImageNamed: "SetbackModeMenuIcon", title: "Economy", action: #selector(onSetbackSelected))
        addMenuItem(withImageNamed: "OffModeMenuIcon", title: "Off", action: #selector(onOffSelected))
        label.setHidden(true)
        temperatureLabel.setHidden(false)
        modeLabel.setHidden(false)
        autoLabel.setHidden(false)
        modeLabel.setText(ProgrammeModeFormatter.asString(model.programme))
        modeLabel.setTextColor(ProgrammeModeColor.colorForMode(model.programme))
        temperatureLabel.setText(TemperatureFormatter.asString(model.temperature))
        temperatureLabel.setTextColor(TemperatureColor.colorForTemperature(model.temperature))
        if(model.programme.inOverride || !model.programme.heatingEnabled) {
            autoLabel.setText("MANUAL")
            autoLabel.setTextColor(ProgrammeModeColor.offColor)
        }
        else {
            autoLabel.setText("AUTO")
            autoLabel.setTextColor(ProgrammeModeColor.autoColor)
        }
    }
    
    private func displayNoData() {
        clearAllMenuItems()
        label.setHidden(false)
        temperatureLabel.setHidden(true)
        modeLabel.setHidden(true)
        autoLabel.setHidden(true)
        label.setText("No data")
    }
    
    private func displaySignedOut() {
        clearAllMenuItems()
        label.setHidden(false)
        autoLabel.setHidden(true)
        temperatureLabel.setHidden(true)
        modeLabel.setHidden(true)
        label.setText("Not Signed In")
    }
    
    @objc func onAutoSelected() {
        (WKExtension.shared().delegate as! ExtensionDelegate).setHeatingMode(.Auto)
    }
    
    @objc func onComfortSelected() {
        (WKExtension.shared().delegate as! ExtensionDelegate).setHeatingMode(.Comfort)
    }
    
    @objc func onSetbackSelected() {
        (WKExtension.shared().delegate as! ExtensionDelegate).setHeatingMode(.Setback)
    }
    
    @objc func onOffSelected() {
        (WKExtension.shared().delegate as! ExtensionDelegate).setHeatingMode(.Off)
    }
}
