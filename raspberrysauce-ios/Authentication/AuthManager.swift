//
//  AuthManager.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 20/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation

protocol AuthObserver : class {
    func onSignedIn()
    func onSignInFailed()
    func onSignedOut()
}

protocol AuthManager {
    func isSignedIn() -> Bool
    func signIn(username: String, password: String)
    func signOut()
    func setAuthObserver(observer: AuthObserver?)
    func getAccessToken() -> Token?
    func deleteAccessToken()
}
