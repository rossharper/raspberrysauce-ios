//
//  TemperatureValueStepper.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 20/03/2021.
//  Copyright © 2021 rossharper.net. All rights reserved.
//

import SwiftUI

struct TemperatureValueStepper: View {
    var value: Temperature
    var onIncrement: () -> Void = {}
    var onDecrement: () -> Void = {}
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Default Comfort Setpoint")
                .foregroundColor(.accentColor)
            HStack() {
                Stepper(
                    onIncrement: onIncrement,
                    onDecrement: onDecrement,
                    label: {
                        Text(value.description)
                    })
            }
        }
        .padding()
    }
}

struct TemperatureValueStepper_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureValueStepper(value: Temperature(value: 20.0))
    }
}
