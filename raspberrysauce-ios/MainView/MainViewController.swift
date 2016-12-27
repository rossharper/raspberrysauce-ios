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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let temperatureProvider = TemperatureProviderFactory.create()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(forName: .UIApplicationWillEnterForeground, object: nil, queue: nil, using:didEnterForeground)
        
        self.loadTemperature()
    }

    @IBAction func onSignOutPressed(_ sender: Any) {
        AuthManagerFactory.create().signOut()
    }
    
    private func loadTemperature() {
        self.temperatureProvider.getTemperature { temperature in
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = true
                self.temperatureLabel.text = TemperatureFormatter.asString(temperature)
            }
        }
    }
    
    func didEnterForeground(notification: Notification) {
        self.loadTemperature()
    }
}
