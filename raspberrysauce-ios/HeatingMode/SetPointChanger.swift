//
//  SetPointChanger.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 21/12/2018.
//  Copyright © 2018 rossharper.net. All rights reserved.
//

import Foundation

protocol SetPointChanger {
    func setComfortSetPoint(temperature: Temperature, onSuccess: @escaping (Temperature) -> Void, onError: @escaping () -> Void)
}
