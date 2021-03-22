//
//  AuthenticatedNetworking.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 20/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation
import Combine

protocol TokenProvider {
    func getAccessToken() -> Token?
}

protocol AuthorizationFailureListener {
    func onAuthorizationFailure()
}

class AuthenticatedNetworking : Networking {
    
    let networking : Networking
    let tokenProvider: TokenProvider
    let authorizationFailureListener : AuthorizationFailureListener
    
    init(networking: Networking, tokenProvider: TokenProvider, authorizationFailureListener: AuthorizationFailureListener) {
        self.networking = networking
        self.tokenProvider = tokenProvider
        self.authorizationFailureListener = authorizationFailureListener
    }
    
    func authenticationErrorHandlerDecorator(_ errorHandler: @escaping (Int?) -> Void) -> ((Int?) -> Void) {
        return { httpStatusCode in
            if(httpStatusCode == 401) {
                self.authorizationFailureListener.onAuthorizationFailure()
            }
            errorHandler(httpStatusCode)
        }
    }
    
    func get(url: URL, onSuccess: @escaping (_ responseBody: Data) -> Void, onError: @escaping (Int?) -> Void) {
        self.get(url: url, headers: nil, onSuccess: onSuccess, onError: onError)
    }
    
    func get(url: URL, headers: [String : String]?, onSuccess: @escaping (_ responseBody: Data) -> Void, onError: @escaping (Int?) -> Void) {
        let appendedHeaders = addAuthorizationHeader(headers: headers)
        if appendedHeaders == nil {
            onError(nil)
            return
        }
        networking.get(url: url, headers: appendedHeaders, onSuccess: onSuccess, onError: authenticationErrorHandlerDecorator(onError))
    }
    
    @available(watchOSApplicationExtension 6.0, *)
    func get(_ url: URL) -> AnyPublisher<Data, Error> {
        return self.get(url, headers: nil)
    }
    
    @available(watchOSApplicationExtension 6.0, *)
    func get(_ url: URL, headers: [String : String]?) -> AnyPublisher<Data, Error> {
        let appendedHeaders = addAuthorizationHeader(headers: headers)
        if appendedHeaders == nil {
            return Fail(error: NSError(domain: "AuthenticatedNetworking Error, no headers", code: 42)).eraseToAnyPublisher()
        }
        return networking.get(url, headers: appendedHeaders)
    }
    
    func post(url: URL, body: String, onSuccess: @escaping (_ responseBody: Data) -> Void, onError: @escaping (Int?) -> Void) {
        self.post(url: url, headers: nil, body: body, onSuccess: onSuccess, onError: onError)
    }
    
    func post(url: URL, headers: [String : String]?, body: String, onSuccess: @escaping (_ responseBody: Data) -> Void, onError: @escaping (Int?) -> Void) {
        let appendedHeaders = addAuthorizationHeader(headers: headers)
        if appendedHeaders == nil {
            onError(nil)
            return
        }
        networking.post(url: url, headers: appendedHeaders, body: body, onSuccess: onSuccess, onError: authenticationErrorHandlerDecorator(onError))
    }
    
    @available(watchOSApplicationExtension 6.0, *)
    func post(_ url: URL, body: String) -> AnyPublisher<Data, Error> {
        return self.post(url, headers: nil, body: body)
    }
    
    @available(watchOSApplicationExtension 6.0, *)
    func post(_ url: URL, headers: [String : String]?, body: String) -> AnyPublisher<Data, Error> {
        let appendedHeaders = addAuthorizationHeader(headers: headers)
        if appendedHeaders == nil {
            return Fail(error: NSError(domain: "AuthenticatedNetworking Error, no headers", code: 42)).eraseToAnyPublisher()
        }
        return networking.post(url, headers: appendedHeaders, body: body)
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
