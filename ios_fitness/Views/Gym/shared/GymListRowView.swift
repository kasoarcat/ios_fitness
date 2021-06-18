//
//  GymListRowView.swift
//  ios_fitness
//
//  Created by 范桶 on 2021/6/12.
//

import SwiftUI

struct GymListRowView: View {
    var actionNames = ActionEnum.allCases
    var title: String
    var actions: [ActionModel]

    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.title)
                    .fontWeight(.heavy)
                Spacer()
            }
            .padding(.leading, 30.0)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 30.0) {
                    ForEach(actions) { item in
                        NavigationLink(destination: GymView(actionEnum: item.title)) {
                            GeometryReader { geometry in
                                ActionView(title: item.title,
                                           image: item.image,
                                           color: item.color,
                                           shadowColor: item.shadowColor)
                                    .rotation3DEffect(Angle(degrees:
                                                                Double(geometry.frame(in: .global).minX - 30) / -40), axis: (x: 0, y: 10.0, z: 0))
                            }
                            .frame(width: 246, height: 360)
                        }
                        
                    }
                }
                .padding(.leading, 30)
                .padding(.top, 30)
                .padding(.bottom, 70)
                Spacer()
            }
        }
        
    }
}

struct GymListRowView_Previews: PreviewProvider {
    static var previews: some View {
        GymListRowView(title: "全身運動", actions: [
            ActionModel(title: ActionEnum.allCases[0],
                        image: "Image1",
                        color: Color("background3"),
                        shadowColor: Color("backgroundShadow3")),
            ActionModel(title: ActionEnum.allCases[1],
                        image: "Image2",
                        color: Color("background4"),
                        shadowColor: Color("backgroundShadow4")),
            ActionModel(title: ActionEnum.allCases[2],
                        image: "Image1",
                        color: Color("background7"),
                        shadowColor: Color(hue: 0.677, saturation: 0.701, brightness: 0.788, opacity: 0.5)),
        ])
    }
}

