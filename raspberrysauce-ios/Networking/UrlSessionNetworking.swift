//
//  UrlSessionNetworking.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 20/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation
import Combine

class UrlSessionNetworking : Networking {

    let urlSession : URLSession

    init(_ urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func get(url: URL, onSuccess: @escaping (_ responseBody: Data) -> Void, onError: @escaping (Int?) -> Void) {
        self.get(url: url, headers: nil, onSuccess: onSuccess, onError: onError)
    }

    func get(url: URL, headers: [String : String]?, onSuccess: @escaping (_ responseBody: Data) -> Void, onError: @escaping (Int?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        self.doRequest(request: &request, headers: headers, onSuccess: onSuccess, onError: onError)
    }
    
    @available(watchOSApplicationExtension 6.0, *)
    func get(_ url: URL) -> AnyPublisher<Data, Error> {
        return self.get(url, headers: nil)
    }
    
    @available(watchOSApplicationExtension 6.0, *)
    func get(_ url: URL, headers: [String : String]?) -> AnyPublisher<Data, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return doRequest(&request, headers: headers)
    }

    func post(url: URL, body: String, onSuccess: @escaping (_ responseBody: Data) -> Void, onError: @escaping (Int?) -> Void) {
        self.post(url: url, headers: nil, body: body, onSuccess: onSuccess, onError: onError)
    }

    func post(url: URL, headers: [String : String]?, body: String, onSuccess: @escaping (_ responseBody: Data) -> Void, onError: @escaping (Int?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body.data(using: .utf8)

        self.doRequest(request: &request, headers: headers, onSuccess: onSuccess, onError: onError)
    }
    
    @available(watchOSApplicationExtension 6.0, *)
    func post(_ url: URL, body: String) -> AnyPublisher<Data, Error> {
        return self.post(url, headers: nil, body: body)
    }
    
    @available(watchOSApplicationExtension 6.0, *)
    func post(_ url: URL, headers: [String : String]?, body: String) -> AnyPublisher<Data, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body.data(using: .utf8)
        
        return self.doRequest(&request, headers: headers)
    }

    private func doRequest(request: inout URLRequest, headers: [String : String]?, onSuccess: @escaping (_ responseBody: Data) -> Void, onError: @escaping (Int?) -> Void) {
        if headers != nil {
            for key in headers!.keys {
                request.addValue(headers![key]!, forHTTPHeaderField: key)
            }
        }
        let task = urlSession.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                onError(nil)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                if let data = String(data: data, encoding: String.Encoding.utf8) {
                    print(data)
                }
                onError(httpStatus.statusCode)
            }
            else {
                onSuccess(data)
            }
        }
        task.resume()
    }
    
    @available(watchOSApplicationExtension 6.0, *)
    func doRequest(_ request: inout URLRequest, headers: [String : String]?) -> AnyPublisher<Data, Error> {
        if let headers = headers {
            for key in headers.keys {
                request.addValue(headers[key]!, forHTTPHeaderField: key)
            }
        }
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                
                if httpResponse.statusCode != 200 {
                    if let data = String(data: element.data, encoding: String.Encoding.utf8) {
                        print(data)
                    }
                    throw URLError(.badServerResponse)
                }
                
                return element.data
            }
            .eraseToAnyPublisher()
    }
 }
