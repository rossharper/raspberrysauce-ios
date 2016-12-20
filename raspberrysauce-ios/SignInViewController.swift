//
//  SignInViewController.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 20/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, AuthObserver {

    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    private let authManager : AuthManager = AuthManagerFactory.create()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authManager.setAuthObserver(observer: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        print("onsignin")
        authManager.signIn(username: userNameField.text!, password: passwordField.text!)
    }
    
    func onSignedIn() {
    }
    
    func onSignedOut() {
    }
    
    func onSignInFailed() {
        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: nil)
        }
    }
}
