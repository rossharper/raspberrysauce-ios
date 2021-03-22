//
//  HeatingModePicker.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 22/03/2021.
//  Copyright © 2021 rossharper.net. All rights reserved.
//

import SwiftUI

struct HeatingModePicker: View {
    @State private var mode: HeatingMode
    private let onChange: (HeatingMode) -> Void
    
    init(heatingMode: HeatingMode, onChange: @escaping (HeatingMode) -> Void) {
        _mode = State(initialValue: heatingMode)
        self.onChange = onChange
    }
    
    var body: some View {
        Picker(selection: $mode, label: Text("Mode")) {
            ForEach(HeatingMode.allCases, id: \.self) { type in
                Text(type.rawValue).tag(type.rawValue)
            }
        }
        .onChange(of: mode, perform: onChange)
        .pickerStyle(SegmentedPickerStyle())
        Spacer()
    }
}

struct HeatingModePicker_Previews: PreviewProvider {
    static var previews: some View {
        HeatingModePicker(heatingMode: .Auto) { _ in }
    }
}
