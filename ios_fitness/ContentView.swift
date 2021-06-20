//
//  ContentView.swift
//  ios_fitness
//
//  Created by jakey on 2021/5/19.
//

import SwiftUI

struct ContentView: View {
    @StateObject var audioManager = AudioManager()
    
    var body: some View {
        TabView {
            GymListView()
                .tabItem {
                    Image(systemName: "music.house.fill")
                    Text("運動場")
                }
                .environmentObject(audioManager)
            ReportView()
                .tabItem {
                    Image(systemName: "music.house.fill")
                    Text("報告")
                }
                .environmentObject(audioManager)
            MySettingView()
                .tabItem {
                    Image(systemName: "music.house.fill")
                    Text("我的設定")
                }
                .environmentObject(audioManager)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
