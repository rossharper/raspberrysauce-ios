//
//  HomeViewRepository.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 22/03/2021.
//  Copyright © 2021 rossharper.net. All rights reserved.
//

import Foundation
import Combine

protocol HomeViewRepository {
    func load() -> AnyPublisher<HomeViewDataV2, SauceApiError>
}

struct HomeViewDataV2: Codable {
    let heatingMode: HeatingMode
}
