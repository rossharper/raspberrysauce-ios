//
//  HeatingModeChanger.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 22/12/2016.
//  Copyright © 2016 rossharper.net. All rights reserved.
//

import Foundation

protocol HeatingModeChanger {
    func setHeatingMode(mode: HeatingMode, onSuccess: @escaping (Programme) -> Void, onError: @escaping () -> Void)
}
