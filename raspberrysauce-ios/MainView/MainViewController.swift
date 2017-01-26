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
    
    let authManager = AuthManagerFactory.create()
    let homeViewDataProvider = HomeViewDataProviderFactory.create()
    let heatingModeChanger = HeatingModeChangerFactory.create()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(forName: .UIApplicationWillEnterForeground, object: nil, queue: nil, using:didEnterForeground)
        
        self.loadData()
    }

    @IBAction func onSignOutPressed(_ sender: Any) {
        AuthManagerFactory.create().signOut()
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
            self.temperatureLabel.text = TemperatureFormatter.asString(homeViewData.temperature)
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
    
    // TODO: duplication between this and watch extension delegate
    func setHeatingMode(_ mode: HeatingMode) {
        print("set heating mode" + mode.description)
        if(authManager.isSignedIn()) {
            heatingModeChanger.setHeatingMode(mode: mode, onSuccess: { (programme) in
                print("mode set")
                DispatchQueue.main.async {
                    self.setModeSelector(programme)
                    self.setModeIcon(programme)
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
