//
//  SettingView.swift
//  ios_fitness
//
//  Created by jakey on 2021/5/19.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("設定")
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
