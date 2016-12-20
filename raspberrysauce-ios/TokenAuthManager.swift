//
//  TokenAuthManager.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 20/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation

struct AuthConfig {
    let tokenRequestEndpoint: URL
}

class TokenAuthManager : AuthManager {
    
    let config : AuthConfig
    let networking : Networking
    let tokenStore : TokenStore
    weak var observer : AuthObserver?
    
    init(config: AuthConfig, networking: Networking, tokenStore: TokenStore) {
        self.config = config
        self.networking = networking
        self.tokenStore = tokenStore
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue:"SignIn"), object: nil, queue: nil, using:notifySignIn)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue:"SignInFailed"), object: nil, queue: nil, using:notifySignInFailed)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue:"SignedOut"), object: nil, queue: nil, using:notifySignedOut)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func isSignedIn() -> Bool {
        let token = tokenStore.get()
        return token != nil
    }
    
    func signIn(username: String, password: String) {
        networking.post(url: config.tokenRequestEndpoint, body: "username=\(username)&password=\(password)",
            onSuccess: {responseBody in
                guard let tokenValue = String(data: responseBody, encoding: .utf8) else {
                    return
                }
                self.tokenStore.put(token: Token(value: tokenValue))
                self.broadcastSignIn()
        },
            onError: {
                self.broadcastSignInFailed()
        })
    }
    
    func signOut() {
        tokenStore.remove()
        broadcastSignedOut()
    }
    
    func setAuthObserver(observer: AuthObserver?) {
        self.observer = observer
    }
    
    func getAccessToken() -> Token? {
        return tokenStore.get()
    }
    
    private func broadcastSignIn() {
        NotificationCenter.default.post(name: Notification.Name(rawValue:"SignIn"), object: nil,userInfo: nil)
    }
    
    private func broadcastSignInFailed() {
        NotificationCenter.default.post(name: Notification.Name(rawValue:"SignInFailed"), object: nil,userInfo: nil)
    }
    
    private func broadcastSignedOut() {
        NotificationCenter.default.post(name: Notification.Name(rawValue:"SignedOut"), object: nil,userInfo: nil)
    }
    
    @objc func notifySignIn(notification: Notification) {
        observer?.onSignedIn()
    }
    
    @objc private func notifySignInFailed(notification: Notification) {
        observer?.onSignInFailed()
    }
    
    @objc private func notifySignedOut(notification: Notification) {
        observer?.onSignedOut()
    }
}
