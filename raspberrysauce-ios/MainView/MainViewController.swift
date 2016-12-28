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
    
    let homeViewDataProvider = HomeViewDataProviderFactory.create()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(forName: .UIApplicationWillEnterForeground, object: nil, queue: nil, using:didEnterForeground)
        
        self.loadData()
    }

    @IBAction func onSignOutPressed(_ sender: Any) {
        AuthManagerFactory.create().signOut()
    }
    
    private func loadData() {
        performSegue(withIdentifier: "DisplayLoadingView", sender: self)
        self.homeViewDataProvider.getHomeViewData(onReceived: { homeViewData in
            DispatchQueue.main.async {
                self.setModeSelector(homeViewData.programme)
                self.temperatureLabel.text = TemperatureFormatter.asString(homeViewData.temperature)
                self.dismiss(animated: true)
            }
        })
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
    
    @IBAction func onModeSelected(_ sender: Any) {
    }
    
    func didEnterForeground(notification: Notification) {
        self.loadData()
    }
}
