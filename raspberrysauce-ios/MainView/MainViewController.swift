//
//  MainViewController.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 20/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var modeSelector: UISegmentedControl!
    @IBOutlet weak var modeIcon: UIImageView!
    @IBOutlet weak var heatIcon: UIImageView!
    @IBOutlet weak var comfortSetpointValue: UITextField!
    @IBOutlet weak var comfortSetpointStepper: UIStepper!
    
    let authManager = AuthManagerFactory.create()
    let homeViewDataProvider = HomeViewDataProviderFactory.create()
    let heatingModeChanger = HeatingModeChangerFactory.create()
    let setPointChanger = SetPointChangerFactory.create()
    
    var stepperInteractionTask: DispatchWorkItem? = nil
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: nil, using:didEnterForeground)
        
        self.loadData()
    }
    
    private func loadData() {
        showLoadingScreen()
        self.homeViewDataProvider.getHomeViewData(onReceived: { homeViewData in
            self.updateDisplay(homeViewData)
        })
    }
    
    private func showLoadingScreen() {
        performSegue(withIdentifier: "DisplayLoadingView", sender: self)
    }
    
    private func hideLoadingScreen() {
        self.dismiss(animated: true)
    }
    
    private func updateDisplay(_ homeViewData: HomeViewData) {
        DispatchQueue.main.async { 
            self.setModeSelector(homeViewData.programme)
            self.setModeIcon(homeViewData.programme)
            self.setHeatIcon(homeViewData.callingForHeat)
            self.temperatureLabel.text = TemperatureFormatter.asString(homeViewData.temperature)
            self.comfortSetpointStepper.value = homeViewData.programme.comfortSetPoint
            self.comfortSetpointValue.text = homeViewData.programme.comfortSetPoint.description
            self.hideLoadingScreen()
        }
    }
    
    private func setModeSelector(_ programme: Programme) {
        switch(programme.heatingEnabled, programme.comfortLevelEnabled, programme.inOverride) {
        case (false, _, _):
            modeSelector.selectedSegmentIndex = 3
        case (true, _, false):
            modeSelector.selectedSegmentIndex = 0
        case (true, true, true):
            modeSelector.selectedSegmentIndex = 1
        case (true, false, true):
            modeSelector.selectedSegmentIndex = 2
        }
    }
    
    private func setModeIcon(_ programme: Programme) {
        switch(programme.heatingEnabled, programme.comfortLevelEnabled) {
        case (false, _):
            modeIcon.image = #imageLiteral(resourceName: "OffModeIcon")
        case (true, true):
            modeIcon.image = #imageLiteral(resourceName: "ComfortModeIcon")
        case (true, false):
            modeIcon.image = #imageLiteral(resourceName: "SetbackModeIcon")
        }
        modeIcon.image = modeIcon.image?.withRenderingMode(.alwaysTemplate)
        modeIcon.tintColor = ProgrammeModeColor.colorForMode(programme)
    }
    
    @IBAction func onModeSelected(_ sender: Any) {
        switch(modeSelector.selectedSegmentIndex) {
        case 1:
            setHeatingMode(.Comfort)
        case 2:
            setHeatingMode(.Setback)
        case 3:
            setHeatingMode(.Off)
        default:
            setHeatingMode(.Auto)
        }
    }
    
    @IBAction func onComfortSetpointStepperChanged(_ sender: Any) {
        
        if let stepperInteractionTask = stepperInteractionTask {
            stepperInteractionTask.cancel()
        }
        
        let temperature = Temperature(value: self.comfortSetpointStepper.value)
        comfortSetpointValue.text = temperature.description
        
        stepperInteractionTask = DispatchWorkItem {
            self.comfortSetpointValue.isEnabled = false
            self.comfortSetpointStepper.isEnabled = false
            self.setComfortSetPoint(temperature: temperature)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: stepperInteractionTask!)
    }
    
    func setHeatIcon(_ callingForHeat: Bool) {
        heatIcon.isHidden = !callingForHeat
        heatIcon.image = #imageLiteral(resourceName: "FireIcon").withRenderingMode(.alwaysTemplate)
        heatIcon.tintColor = UIColor(
            red: CGFloat(0.767),
            green: CGFloat(0.082),
            blue: CGFloat(0.247),
            alpha: CGFloat(1.0))
    }
    
    func setComfortSetPoint(temperature: Temperature) {
        setPointChanger.setComfortSetPoint(temperature: temperature, onSuccess: { (temperature) in
            DispatchQueue.main.async {
                self.comfortSetpointValue.text = temperature.description
            }
        }) {
            print("error setting setpoint")
        }
        self.comfortSetpointValue.isEnabled = true
        self.comfortSetpointStepper.isEnabled = true
    }
    
    // TODO: duplication between this and watch extension delegate
    func setHeatingMode(_ mode: HeatingMode) {
        print("set heating mode" + mode.description)
        if(authManager.isSignedIn()) {
            heatingModeChanger.setHeatingMode(mode: mode, onSuccess: { (heatingModeChanged) in
                print("mode set")
                DispatchQueue.main.async {
                    self.setModeSelector(heatingModeChanged.programme)
                    self.setModeIcon(heatingModeChanged.programme)
                    self.setHeatIcon(heatingModeChanged.callingForHeat)
                }
            }) {
                print("error setting heating mode")
            }
        }
    }
    
    func didEnterForeground(notification: Notification) {
        self.loadData()
    }
}
