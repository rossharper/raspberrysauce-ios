//
//  Networking.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 20/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation
import Combine

protocol Networking {
    func get(url: URL, onSuccess: @escaping (_ responseBody: Data) -> Void, onError: @escaping (Int?) -> Void)
    func get(url: URL, headers: [String : String]?, onSuccess: @escaping (_ responseBody: Data) -> Void, onError: @escaping (Int?) -> Void)
    @available(watchOSApplicationExtension 6.0, *)
    func get(_ url: URL) -> AnyPublisher<Data, Error>
    @available(watchOSApplicationExtension 6.0, *)
    func get(_ url: URL, headers: [String : String]?) -> AnyPublisher<Data, Error>
    func post(url: URL, body: String, onSuccess: @escaping (_ responseBody: Data) -> Void, onError: @escaping (Int?) -> Void)
    func post(url: URL, headers: [String : String]?, body: String, onSuccess: @escaping (_ responseBody: Data) -> Void, onError: @escaping (Int?) -> Void)
    @available(watchOSApplicationExtension 6.0, *)
    func post(_ url: URL, body: String) -> AnyPublisher<Data, Error>
    @available(watchOSApplicationExtension 6.0, *)
    func post(_ url: URL, headers: [String : String]?, body: String) -> AnyPublisher<Data, Error>
}
