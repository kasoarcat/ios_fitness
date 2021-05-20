//
//  GymView.swift
//  ios_fitness
//
//  Created by jakey on 2021/5/19.
//

import SwiftUI

func unityShow() {
//    Unity.shared.show()
}

struct GymView: View {
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("運動場")
                
                Button(action: {
                    unityShow()
                }) {
                    Text("Launch Unity!")
                }
            }
        }
    }
}

struct GymView_Previews: PreviewProvider {
    static var previews: some View {
        GymView()
    }
}
