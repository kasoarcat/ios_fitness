//
//  GymListView.swift
//  ios_fitness
//
//  Created by jakey on 2021/6/6.
//

import SwiftUI

struct GymListView: View {
    var actionNames = ActionEnum.allCases
    var bodyActions = bodyActionsData
    var buttActions = buttActionsData
    var feetActions = feetActionsData
    
    @EnvironmentObject var userDefaultManager: UserDefaultManager
    @State private var showAlert = false
        
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    GymListRowView(title: "全身運動", actions: bodyActionsData)
                    GymListRowView(title: "臀部運動", actions: buttActions)
                    GymListRowView(title: "腳步運動", actions: feetActions)
                }
                .padding(.top, 78)
            }
            .navigationTitle("運動")
            .alert(isPresented: $showAlert) { () -> Alert in
                return Alert(title: Text(userDefaultManager.message))
            }
            .onAppear {
                // Delay of 1 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if userDefaultManager.message.count > 0 {
                        showAlert = true
                    }
//                    print("message2: \(userDefaultManager.message)")
                }
                
            }
        }
    }
}

struct GymListView_Previews: PreviewProvider {
    static var previews: some View {
        GymListView()
    }
}

let bodyActionsData = [
    ActionModel(title: ActionEnum.allCases[0],
                image: "Image1",
                color: Color("background3"),
                shadowColor: Color("backgroundShadow3")),
    
    ActionModel(title: ActionEnum.allCases[2],
                image: "Image1",
                color: Color("background7"),
                shadowColor: Color(hue: 0.677, saturation: 0.701, brightness: 0.788, opacity: 0.5)),
    ActionModel(title: ActionEnum.allCases[3],
                image: "Image5",
                color: Color("background8"),
                shadowColor: Color(hue: 0.677, saturation: 0.701, brightness: 0.788, opacity: 0.5)),
    
               
    
    ActionModel(title: ActionEnum.allCases[7],
                image: "Image1",
                color: Color("background7"),
                shadowColor: Color(hue: 0.677, saturation: 0.701, brightness: 0.788, opacity: 0.5)),
]

let buttActionsData = [
    ActionModel(title: ActionEnum.allCases[1],
                image: "Image2",
                color: Color("background4"),
                shadowColor: Color("backgroundShadow4")),
    ActionModel(title: ActionEnum.allCases[4],
                image: "Image1",
                color: Color("background9"),
                shadowColor: Color(hue: 0.677, saturation: 0.701, brightness: 0.788, opacity: 0.5)),
    ActionModel(title: ActionEnum.allCases[5],
                image: "Image2",
                color: Color("background3"),
                shadowColor: Color(hue: 0.677, saturation: 0.701, brightness: 0.788, opacity: 0.5)),
]

let feetActionsData = [
    ActionModel(title: ActionEnum.allCases[6],
                image: "Image3",
                color: Color("background4"),
                shadowColor: Color(hue: 0.677, saturation: 0.701, brightness: 0.788, opacity: 0.5)),
]
