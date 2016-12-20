//
//  UrlSessionNetworking.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 20/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation

class UrlSessionNetworking : Networking {

    func get(url: URL, onSuccess: @escaping (_ responseBody: Data) -> Void, onError: @escaping () -> Void) {
        self.get(url: url, headers: nil, onSuccess: onSuccess, onError: onError)
    }
    
    func get(url: URL, headers: [String : String]?, onSuccess: @escaping (_ responseBody: Data) -> Void, onError: @escaping () -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        self.doRequest(request: &request, headers: headers, onSuccess: onSuccess, onError: onError)
    }
    
    func post(url: URL, body: String, onSuccess: @escaping (_ responseBody: Data) -> Void, onError: @escaping () -> Void) {
        self.post(url: url, headers: nil, body: body, onSuccess: onSuccess, onError: onError)
    }
    
    func post(url: URL, headers: [String : String]?, body: String, onSuccess: @escaping (_ responseBody: Data) -> Void, onError: @escaping () -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body.data(using: .utf8)
        
        self.doRequest(request: &request, headers: headers, onSuccess: onSuccess, onError: onError)
    }
    
    private func doRequest(request: inout URLRequest, headers: [String : String]?, onSuccess: @escaping (_ responseBody: Data) -> Void, onError: @escaping () -> Void) {
        if headers != nil {
            for key in headers!.keys {
                request.addValue(headers![key]!, forHTTPHeaderField: key)
            }
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                onError()
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                onError()
            }
            else {
                onSuccess(data)
            }
        }
        task.resume()
    }
 }
