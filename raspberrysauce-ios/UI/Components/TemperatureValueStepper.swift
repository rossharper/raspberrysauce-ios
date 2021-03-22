//
//  TemperatureValueStepper.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 20/03/2021.
//  Copyright © 2021 rossharper.net. All rights reserved.
//

import SwiftUI

struct TemperatureValueStepper: View {

    private let onChanged: (Temperature) -> Void
    
    @State private var tempValue: Double
    
    init(value: Temperature, onChanged: @escaping ((Temperature) -> Void) = { _ in }) {
        self.onChanged = onChanged
        _tempValue = State(initialValue: value.value)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Default Comfort Setpoint")
                .foregroundColor(.accentColor)
            HStack() {
                Stepper(
                    tempValue.description,
                    value: $tempValue,
                    in: 0...30,
                    step: 0.5
                ).onChange(of: tempValue) { _ in
                    onChanged(Temperature(value: tempValue))
                }
                    
                
                
//
//                    onIncrement: {
//                        onIncrement(value)
//                    },
//                    onDecrement: {
//                        onDecrement(value)
//                    },
//                    label: {
//                        Text(value.description)
//                    })
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
