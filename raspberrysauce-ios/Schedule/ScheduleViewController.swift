//
//  ScheduleViewController.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 26/11/2017.
//  Copyright © 2017 rossharper.net. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let homeViewDataProvider = HomeViewDataProviderFactory.create()
    
    var schedulePeriods : [ProgrammePeriod] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(forName: .UIApplicationWillEnterForeground, object: nil, queue: nil, using:didEnterForeground)
        
        self.loadData()
    }
    
    private func loadData() {
        showLoadingScreen()
        self.homeViewDataProvider.getHomeViewData(onReceived: { homeViewData in
            self.updateDisplay(homeViewData: homeViewData)
        })
    }
    
    private func updateDisplay(homeViewData : HomeViewData) {
        DispatchQueue.main.async {
            self.schedulePeriods = homeViewData.programme.periods
            self.tableView.reloadData()
            self.hideLoadingScreen()
        }
    }
    
    private func showLoadingScreen() {
        performSegue(withIdentifier: "DisplayProgLoadingView", sender: self)
    }
    
    private func hideLoadingScreen() {
        self.dismiss(animated: true)
    }
    
    func didEnterForeground(notification: Notification) {
        self.loadData()
    }
}

extension ScheduleViewController : UITableViewDelegate {
    
}

extension ScheduleViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
            ?? UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        
        let period = schedulePeriods[indexPath.item]
        
        cell.textLabel?.text = "\(comfortString(period.isComfort)): \(period.startTime) — \(period.startTime)"
        
        return cell
    }
    
    private func comfortString(_ isComfort: Bool) -> String {
        if(isComfort) {
            return "Comfort"
        }
        else {
            return "Economy"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.schedulePeriods.count
    }
}
