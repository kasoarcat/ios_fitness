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
    @EnvironmentObject var userDefaultManager: UserDefaultManager
    @EnvironmentObject var audioManager: AudioManager
    
    var actionNames = ActionEnum.allCases
    let startDate = Date()
    
    @State var actionEnum: ActionEnum
    @State var count: Int = 0
    @State private var showSheetView = false
    
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Actions.endDate, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Actions>
    
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \MySetting.weight, ascending: true)],
//        animation: .default)
//    private var setting: FetchedResults<MySetting>
    
    private func addAction() -> String {
        withAnimation {
            let action = Actions(context: viewContext)
            action.id = UUID()
            action.name = actionEnum.rawValue
            action.startDate = startDate
            action.endDate = Date()
            action.count = Int16(count)
            
            var percent = 1.0
            if userDefaultManager.weight >= 70 {                // 70KG以上
                percent = 1.2
            }
            else if userDefaultManager.weight >= 60 {           // 50KG ~ 60KG
                percent = 1.0
            }
            else {                                              // 50KG以下
                percent = 0.8
            }
            
            switch actionEnum {
            case .開合跳:
                action.calories = Int32(Double(50 * count) * percent)
            case .蹲伏:
                action.calories = Int32(Double(10 * count) * percent)
            case .蹲姿上伸:
                action.calories = Int32(Double(25 * count) * percent)
            case .原地提膝踏步:
                action.calories = Int32(Double(10 * count) * percent)
            case .蹲跳運動:
                action.calories = Int32(Double(50 * count) * percent)
            case .深蹲:
                action.calories = Int32(Double(10 * count) * percent)
            case .弓步:
                action.calories = Int32(Double(10 * count) * percent)
            case .交叉勾拳:
                action.calories = Int32(Double(10 * count) * percent)
            }

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            let interval = Int(action.endDate!.timeIntervalSince1970 - startDate.timeIntervalSince1970)
            let min = Int(interval / 60)
            let sec = Int(interval % 60)
            
            return "總共\(min)分\(sec)秒\n\(actionEnum.rawValue)\(count)次\n卡路里\(action.calories)卡"
        }
    }
    
    var body: some View {
//        let formatter: DateFormatter = {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
//            return formatter
//        }()
        
        ZStack {
            ARViewContainer(actionEnum: $actionEnum, count: $count)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
//                List {
//                    ForEach(items) { item in
//                        Text("date: \(formatter.string(from: item.endDate!)) c: \(item.count) \(item.name!) ca: \(item.calories)")
//                    }
//                }
                
//                List {
//                    ForEach(setting) { item in
//                        Text("weight: \(item.weight)")
//                    }
//                }
                
                Spacer()
                Text("計數: \(count)")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.yellow)
            }
        }
        .navigationTitle(actionEnum.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showSheetView) {
            MySettingView()
         }
        .onAppear {
            // 第一次使用
            if userDefaultManager.weight == 0 {
                showSheetView = true
            }
            else {
                audioManager.playMusic()
            }
            
            userDefaultManager.message = ""
        }
        .onDisappear {
            if count > 0 {
                userDefaultManager.message = addAction() // 加入運動資料
            }
            
            audioManager.stopMusic()
            print("message1:\(userDefaultManager.message)")
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
