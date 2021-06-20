//
//  SettingFormRow.swift
//  ios_fitness
//
//  Created by 范桶 on 2021/5/24.
//

import SwiftUI

struct SettingFormRow: View {
    
    var icon: String
    var text: String
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color.gray)
                Image(systemName: icon)
                    .foregroundColor(.white)
            }
            .frame(width: 36, height: 36, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Text(text)
            Spacer()
        }
    }
}

struct SettingFormRow_Previews: PreviewProvider {
    static var previews: some View {
        SettingFormRow(icon: "gear", text: "關於我")
            .previewLayout(.fixed(width: 375, height: 60))
            .padding()
    }
}

