//
//  Temperature.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 20/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation

struct Temperature: Codable {
    let value : Double
    
    init(value: Double) {
        self.value = value
    }
    
    init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer()
        self.value = try value.decode(Double.self)
    }
    
    var description: String {
        return value.description
    }
}
