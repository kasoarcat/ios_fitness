//
//  ContentView.swift
//  Body Tracking
//
//  Created by jakey on 2021/5/13.
//

import SwiftUI

#if arch(arm64)

struct GymView: View {
    var actionNames = ActionEnum.allCases
    @State var actionEnum: ActionEnum = .開合跳
    @State var count: Int = 0
    @State var selectedIndex = 0
        
    var body: some View {
        
        ZStack {
            ARViewContainer(actionEnum: $actionEnum, count: $count)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("count: \(count)")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.yellow)
                Picker(selection: $selectedIndex, label: Text("選擇動作")) {
                    ForEach(0..<actionNames.count) { index in
                        let i = Int(index)
                        Text(actionNames[i].rawValue)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.yellow)
                            .tag(i)
                    }
                }
                Button {
                    count = 0
                    actionEnum = actionNames[selectedIndex]
                } label: {
                    Text("設定")
                        .bold()
                        .font(.largeTitle)
                        .foregroundColor(.yellow)
                }
            }
        }
    }
}

#else

struct GymView: View {
    var body: some View {
        VStack {
            Text("健身房")
        //            ZStack(alignment: .topTrailing) {
        //                TextView(text: $message, textStyle: $textStyle)
        //                    .padding(.horizontal)
        //                Button(action: {
        //                    self.textStyle = (self.textStyle == .body) ? .title1 : .body
        //                }) {
        //                    Image(systemName: "textformat")
        //                        .imageScale(.large)
        //                        .frame(width: 40, height: 40)
        //                        .foregroundColor(.white)
        //                        .background(Color.purple)
        //                        .clipShape(Circle())
        //                }
        //                .padding()
        //            }
        }
    }
}

#endif

struct GymView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GymView()
        }
    }
}
