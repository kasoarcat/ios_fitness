//
//  ContentView.swift
//  Body Tracking
//
//  Created by jakey on 2021/5/13.
//

import SwiftUI

struct GymView: View {
    var body: some View {
        #if arch(arm64)
        return ARViewContainer()
            .edgesIgnoringSafeArea(.all)
        #else
            Text("健身房")
        #endif
    }
}
