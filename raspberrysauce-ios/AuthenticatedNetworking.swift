//
//  AuthenticatedNetworking.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 20/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation

protocol TokenProvider {
    func getAccessToken() -> Token?
}

class AuthenticatedNetworking : Networking {
    
    let networking : Networking
    let tokenProvider: TokenProvider
    
    init(networking: Networking, tokenProvider: TokenProvider) {
        self.networking = networking
        self.tokenProvider = tokenProvider
    }
    
    func get(url: URL, onSuccess: @escaping (_ responseBody: Data) -> Void, onError: @escaping () -> Void) {
        self.get(url: url, headers: nil, onSuccess: onSuccess, onError: onError)
    }
    
    func get(url: URL, headers: [String : String]?, onSuccess: @escaping (_ responseBody: Data) -> Void, onError: @escaping () -> Void) {
        let appendedHeaders = addAuthorizationHeader(headers: headers)
        if appendedHeaders == nil {
            onError()
            return
        }
        networking.get(url: url, headers: appendedHeaders, onSuccess: onSuccess, onError: onError)
    }
    
    func post(url: URL, body: String, onSuccess: @escaping (_ responseBody: Data) -> Void, onError: @escaping () -> Void) {
        self.post(url: url, headers: nil, body: body, onSuccess: onSuccess, onError: onError)
    }
    
    func post(url: URL, headers: [String : String]?, body: String, onSuccess: @escaping (_ responseBody: Data) -> Void, onError: @escaping () -> Void) {
        let appendedHeaders = addAuthorizationHeader(headers: headers)
        if appendedHeaders == nil {
            onError()
            return
        }
        networking.post(url: url, headers: appendedHeaders, body: body, onSuccess: onSuccess, onError: onError)
    }
    
    func addAuthorizationHeader(headers: [String : String]?) -> [String : String]? {
        var appendedHeaders = headers ?? [String : String]()
        let token = tokenProvider.getAccessToken()
        if token == nil {
            return nil
        }
        appendedHeaders["Authorization"] = "Bearer \(token!.value)"
        return appendedHeaders
    }
}
