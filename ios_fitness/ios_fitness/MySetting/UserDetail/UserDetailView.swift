//
//  UserDetailView.swift
//  ios_fitness
//
//  Created by 范桶 on 2021/5/24.
//

import SwiftUI

struct UserDetailView: View {
    @ObservedObject var userDefaultManager = UserDefaultManager()
    
    private let heightFormat = "%d cm"
    private let weightFormat = "%d kg"
    private let genderList: [String] = ["男性", "女性"]
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("個人資料")) {
                    HStack {
                        Text("身高")
                        Picker("", selection: $userDefaultManager.height) {
                            ForEach(60..<250, id: \.self) { number in
                                Text(String(format: heightFormat, number))
                            }
                        }
                    }
                    HStack {
                        Text("體重")
                        Picker("", selection: $userDefaultManager.weight) {
                            ForEach(20..<250, id: \.self) { number in
                                Text(String(format: weightFormat, number))
                            }
                        }
                    }
                    HStack {
                        Text("性別")
                        Spacer()
                        Picker("", selection: $userDefaultManager.gender) {
                            ForEach(genderList.indices) { index in
                                Text(genderList[index])
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 150)
                    }
                }
            }
        }
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView()
    }
}
