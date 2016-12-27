//
//  TokenStore.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 20/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation

protocol TokenStore {
    func put(token: Token)
    func get() -> Token?
    func remove()
}
