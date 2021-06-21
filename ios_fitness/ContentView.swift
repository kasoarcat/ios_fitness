//
//  ContentView.swift
//  ios_fitness
//
//  Created by jakey on 2021/5/19.
//

import SwiftUI

struct ContentView: View {
    @StateObject var audioManager = AudioManager()
    @StateObject var userDefaultManager = UserDefaultManager()
    
    var body: some View {
        TabView {
            GymListView()
                .tabItem {
                    Image(systemName: "music.house.fill")
                    Text("運動場")
                }
                .environmentObject(audioManager)
                .environmentObject(userDefaultManager)
            ReportView()
                .tabItem {
                    Image(systemName: "music.house.fill")
                    Text("報告")
                }
                .environmentObject(audioManager)
                .environmentObject(userDefaultManager)
            MySettingView()
                .tabItem {
                    Image(systemName: "music.house.fill")
                    Text("我的設定")
                }
                .environmentObject(audioManager)
                .environmentObject(userDefaultManager)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
