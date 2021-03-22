//
//  SauceApiHomeViewRepository.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 22/03/2021.
//  Copyright © 2021 rossharper.net. All rights reserved.
//

import Foundation
import Combine

class SauceApiHomeViewRepository {
    private let networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
    }
}

extension SauceApiHomeViewRepository: HomeViewRepository {
    func load() -> AnyPublisher<HomeViewDataV2, SauceApiError> {
        return networking.get(URL(string: SauceApiEndpoints.Views.Home)!)
            .decode(type: HomeViewDataV2.self, decoder: JSONDecoder())
            .mapError {
                SauceApiError(error: $0)
            }
            .eraseToAnyPublisher()
    }
}
