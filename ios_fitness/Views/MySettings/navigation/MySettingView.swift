//
//  ContentView.swift
//  ios_fitness
//
//  Created by jakey on 2021/5/21.
//

import SwiftUI
import CoreData

struct MySettingView: View {
    var body: some View {

        NavigationView {
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 0) {
                Form {
                    NavigationLink(destination: UserDetailView()) {
                        SettingFormRow(icon: "person", text: "關於我")
                    }
                    NavigationLink(destination: NotificationView()) {
                        SettingFormRow(icon: "clock", text: "提醒")
                    }
                    NavigationLink(destination: SoundEffectView()) {
                        SettingFormRow(icon: "speaker.wave.3", text: "音效＆音樂")
                    }


                }
            }
            .navigationBarTitle("個人檔案", displayMode: .inline)
        }
    }
    
}

struct MySettingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MySettingView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}

