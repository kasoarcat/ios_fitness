//
//  ContentView.swift
//  ios_fitness
//
//  Created by jakey on 2021/5/19.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            GymView()
                .tabItem {
                    Image(systemName: "music.house.fill")
                    Text("運動場")
                }
            ReportView()
                .tabItem {
                    Image(systemName: "music.house.fill")
                    Text("報告")
                }
            SettingView()
                .tabItem {
                    Image(systemName: "music.house.fill")
                    Text("我的設定")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
