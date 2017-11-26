//
//  SettingsViewController.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 26/11/2017.
//  Copyright © 2017 rossharper.net. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBAction func onSIgnOutPressed(_ sender: Any) {
        AuthManagerFactory.create().signOut()
    }
}
