//
//  ViewController.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 20/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import UIKit

class ViewController: UIViewController, AuthObserver {
    
    let authManager = AuthManagerFactory.create()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authManager.setAuthObserver(observer: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        if(authManager.isSignedIn()) {
            performSegue(withIdentifier: "DisplayMainViewSegue", sender: self)
        }
        else {
            performSegue(withIdentifier: "DisplaySignInSegue", sender: self)
        }
    }
    
    func onSignedIn() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    func onSignInFailed() {
        
    }
    
    func onSignedOut() {
        DispatchQueue.main.async {
            self.dismiss(animated:true)
        }
    }
}

