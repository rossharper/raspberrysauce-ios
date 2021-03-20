//
//  ErrorView.swift
//  raspberrysauce-ios
//
//  Created by Ross Harper on 20/03/2021.
//  Copyright © 2021 rossharper.net. All rights reserved.
//

import SwiftUI

struct ErrorView: View {
    
    var retry: () -> Void = {}
    
    var body: some View {
        VStack(alignment: .center,
               spacing: 20) {
            Text("Error loading data").font(.title)
            Button("Retry", action: retry)
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
    }
}
