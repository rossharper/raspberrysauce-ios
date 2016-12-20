//
//  AuthManagerFactory.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 20/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation

class AuthManagerFactory {
    static func create() -> AuthManager {
        let config = AuthConfig(tokenRequestEndpoint: URL(string: "\(AppConfig.ApiBaseUrl)/requestAppToken")!)
        return TokenAuthManager(config: config, networking: NetworkingFactory.createNetworking(), tokenStore: UserDefaultsTokenStore())
    }
}
