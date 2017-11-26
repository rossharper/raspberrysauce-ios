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
        
        if(period.isComfort) {
            let image = #imageLiteral(resourceName: "ComfortModeIcon").withRenderingMode(.alwaysTemplate)
            cell.imageView?.image = image
            cell.imageView?.tintColor = ProgrammeModeColor.comfortColor
        } else {
            let image = #imageLiteral(resourceName: "SetbackModeIcon").withRenderingMode(.alwaysTemplate)
            cell.imageView?.image = image
            cell.imageView?.tintColor = ProgrammeModeColor.setbackColor
        }

        cell.textLabel?.text = "\(period.startTime) — \(period.startTime)"
        cell.backgroundColor = #colorLiteral(red: 0.9467939734, green: 0.9468161464, blue: 0.9468042254, alpha: 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.schedulePeriods.count
    }
}
