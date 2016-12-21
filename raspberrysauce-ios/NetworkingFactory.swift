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
        return UrlSessionNetworking()
    }
    
    struct AuthManagerTokenProvider : TokenProvider {
        let authManager : AuthManager
        
        func getAccessToken() -> Token? {
            return authManager.getAccessToken()
        }
    }
    
    static func createAuthentiatedNetworking() -> Networking {
        return AuthenticatedNetworking(networking: createNetworking(), tokenProvider: AuthManagerTokenProvider(authManager: AuthManagerFactory.create()))
    }
}
