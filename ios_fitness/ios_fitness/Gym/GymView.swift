//
//  ContentView.swift
//  Body Tracking
//
//  Created by jakey on 2021/5/13.
//

import SwiftUI

struct GymView: View {
    @State var count: Int = 0
    
    var body: some View {
        #if arch(arm64)
        ZStack {
            ARViewContainer(handCount: $count)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("count: \(count)")
                Button {
                    count = 0
                } label: {
                    Text("清除")
                }

            }
        }
        #else
        VStack {
            Text("健身房")
//            ZStack(alignment: .topTrailing) {
//                TextView(text: $message, textStyle: $textStyle)
//                    .padding(.horizontal)
//                Button(action: {
//                    self.textStyle = (self.textStyle == .body) ? .title1 : .body
//                }) {
//                    Image(systemName: "textformat")
//                        .imageScale(.large)
//                        .frame(width: 40, height: 40)
//                        .foregroundColor(.white)
//                        .background(Color.purple)
//                        .clipShape(Circle())
//                }
//                .padding()
//            }
        }
        #endif
    }
}

struct GymView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GymView()
        }
    }
}