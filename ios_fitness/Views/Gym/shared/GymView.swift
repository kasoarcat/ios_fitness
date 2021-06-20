//
//  ContentView.swift
//  Body Tracking
//
//  Created by jakey on 2021/5/13.
//

import SwiftUI

#if arch(arm64)

struct GymView: View {
    @EnvironmentObject var audioManager: AudioManager
    
    @State var actionEnum: ActionEnum
    var actionNames = ActionEnum.allCases
    @State var count: Int = 0
//    @State var selectedIndex = 0
    @State var isActive: Bool = false
    
    var body: some View {
        ZStack {
            ARViewContainer(actionEnum: $actionEnum, count: $count)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("count: \(count)")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.yellow)
            }
        }
        .navigationTitle(actionEnum.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // 播放音樂
            print("播放音樂")
            audioManager.playMusic()
        }
        .onDisappear {
            // 播放音樂
            print("停止音樂")
            audioManager.stopMusic()
        }
    }
}

#else

struct GymView: View {
    @State var actionEnum: ActionEnum
    @State var isActive: Bool = false
    
    var body: some View {
        VStack {
            Text(actionEnum.rawValue)
                .font(.title)
                .foregroundColor(.blue)
        }
    }
}

#endif

struct GymView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GymView(actionEnum: ActionEnum.開合跳, isActive: true)
        }
    }
}
