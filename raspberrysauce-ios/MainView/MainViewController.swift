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
        performSegue(withIdentifier: "DisplayLoadingView", sender: self)
        self.temperatureProvider.getTemperature { temperature in
            DispatchQueue.main.async {
                self.temperatureLabel.text = TemperatureFormatter.asString(temperature)
                self.dismiss(animated: true)
            }
        }
    }
    
    func didEnterForeground(notification: Notification) {
        self.loadTemperature()
    }
}
