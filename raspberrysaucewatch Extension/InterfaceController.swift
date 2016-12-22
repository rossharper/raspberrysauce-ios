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
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        print("watch awake")
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
        
        extensionDelegate.updateModel() { model in
            self.updateDisplay(model: model)
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func updateDisplay(model: HomeViewData?) {
        guard let model = model else {
            displayNoData()
            return
        }
        
        displayData(model: model)
    }
    
    private func displayData(model : HomeViewData) {
        label.setHidden(true)
        temperatureLabel.setHidden(false)
        modeLabel.setHidden(false)
        modeLabel.setText(ProgrammeModeFormatter.asString(programme: model.programme))
        temperatureLabel.setText(TemperatureFormatter.asString(temperature: model.temperature))
    }
    
    private func displayNoData() {
        label.setHidden(false)
        temperatureLabel.setHidden(true)
        modeLabel.setHidden(true)
        label.setText("No data")
    }
    
    private func displaySignedOut() {
        label.setHidden(false)
        temperatureLabel.setHidden(true)
        modeLabel.setHidden(true)
        label.setText("Not Signed In")
    }
}
