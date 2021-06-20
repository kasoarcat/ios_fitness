//
//  ContentView.swift
//  Body Tracking
//
//  Created by jakey on 2021/5/13.
//

import SwiftUI

#if arch(arm64)

struct GymView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var audioManager: AudioManager
    
    var actionNames = ActionEnum.allCases
    let startDate = Date()
    
    @State var actionEnum: ActionEnum
    @State var count: Int = 0
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Actions.endDate, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Actions>
    
    private func addAction(_ count: Int) {
        withAnimation {
            let action = Actions(context: viewContext)
            action.id = UUID()
            action.name = actionEnum.rawValue
            action.startDate = startDate
            action.endDate = Date()
            action.count = Int16(count)
            action.calories = 50

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    var body: some View {
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            return formatter
        }()
        
        ZStack {
            ARViewContainer(actionEnum: $actionEnum, count: $count)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                List {
                    ForEach(items) { item in
                        Text("date: \(formatter.string(from: item.endDate!)) c: \(item.count) \(item.name!) ca: \(item.calories)")
                    }
                }
                
                Spacer()
                Text("計數: \(count)")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.yellow)
            }
        }
        .navigationTitle(actionEnum.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            audioManager.playMusic()
        }
        .onDisappear {
            audioManager.stopMusic()
            
            if count > 0 {
                addAction(count)
            }
        }
    }
}

#else

struct GymView: View {
    @State var actionEnum: ActionEnum
    
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
            GymView(actionEnum: ActionEnum.開合跳)
        }
    }
}
