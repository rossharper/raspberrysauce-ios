//
//  UserDefaultsTokenStore.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 20/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation

class UserDefaultsTokenStore : TokenStore {
    
    let key = "TokenStoreTokenValue"
    
    func put(token: Token) {
        // TODO: encrypt token?
        getDefaults()?.set(token.value, forKey: key)
    }
    
    func get() -> Token? {
        let tokenValue = getDefaults()?.string(forKey: key)
        if((tokenValue) != nil) {
            return Token(value: tokenValue!)
        }
        else {
            return nil
        }
    }
    
    func remove() {
        getDefaults()?.removeObject(forKey: key)
    }
    
    func getDefaults() -> UserDefaults? {
        return UserDefaults.standard
    }
}
