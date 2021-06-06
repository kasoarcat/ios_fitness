//
//  GymListView.swift
//  ios_fitness
//
//  Created by jakey on 2021/6/6.
//

import SwiftUI

struct GymListView: View {
    var actionNames = ActionEnum.allCases
    
    var body: some View {
        NavigationView {
            VStack {
                Image("GymList")
                    .resizable()
                    .frame(width: 639, height: 335, alignment: .center)
                List {
                    ForEach(0..<actionNames.count) { index in
                        let i = Int(index)
                        NavigationLink(
                            destination: GymView(actionEnum: actionNames[i]),
                            label: {
                                Text(actionNames[i].rawValue)
                                    .font(.title)
                                    .bold()
                            })
                    }

                }
            }
            .navigationTitle("運動清單")
            .navigationBarTitleDisplayMode(.inline)
//            .foregroundColor(.yellow)
        }
        
    }
}

struct GymListView_Previews: PreviewProvider {
    static var previews: some View {
        GymListView()
    }
}
