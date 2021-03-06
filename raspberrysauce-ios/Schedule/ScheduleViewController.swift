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
    
    private let scheduleCellReuseIdentifier = "scheduleCell"
    private let footerCellReuseIdentifier = "footerCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: nil, using:didEnterForeground)
        
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return tableView.dequeueReusableCell(withIdentifier: footerCellReuseIdentifier)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let period = schedulePeriods[indexPath.item]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: scheduleCellReuseIdentifier) as! ScheduleCell
        
        cell.render(period: period, isLast: indexPath.item == schedulePeriods.count - 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.schedulePeriods.count
    }}
