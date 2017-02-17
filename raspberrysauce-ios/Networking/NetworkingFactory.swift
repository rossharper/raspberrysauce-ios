//
//  NetworkingFactory.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 20/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation

class NetworkingFactory {
    static func createNetworking() -> Networking {
        return UrlSessionNetworking(URLSession.shared)
    }
    
    struct AuthManagerTokenProvider : TokenProvider {
        let authManager : AuthManager
        
        func getAccessToken() -> Token? {
            return authManager.getAccessToken()
        }
    }
    
    struct AuthManagerAuthorizationFailureListener : AuthorizationFailureListener {
        let authManager : AuthManager
        
        func onAuthorizationFailure() {
            authManager.deleteAccessToken()
        }
    }
    
    static func createAuthentiatedNetworking() -> Networking {
        let authManager = AuthManagerFactory.create()
        return AuthenticatedNetworking(networking: createNetworking(), tokenProvider: AuthManagerTokenProvider(authManager: authManager), authorizationFailureListener: AuthManagerAuthorizationFailureListener(authManager: authManager))
    }
}
