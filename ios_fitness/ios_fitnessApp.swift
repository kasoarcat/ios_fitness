//
//  ios_fitnessApp.swift
//  ios_fitness
//
//  Created by jakey on 2021/5/21.
//

import SwiftUI

@main
struct ios_fitnessApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
//                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
