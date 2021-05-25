//
//  NotificationView.swift
//  ios_fitness
//
//  Created by 范桶 on 2021/5/25.
//

import SwiftUI
import UserNotifications

struct NotificationView: View {
    @ObservedObject private var notificationViewModel = NotificationViewModel()
    @State var data: [(String, [String])] = [
        ("meridium", ["上午", "下午"]),
        ("hour", Array(1...12).map { "\($0)" }),
        ("minute", Array(0...59).map { "\($0)" })
    ]
    
    var body: some View {
        VStack {
            TimePicker(data: data, selection: $notificationViewModel.selection)
            HStack {
                Text("重複")
                Spacer()
            }
            .padding()
            
            HStack {
                ForEach(Weekday.allCases.indices, id: \.self) { index in
                    Button(action: {
                        notificationViewModel.setWeek(index)
                    }, label: {
                        Text("\(Weekday.allCases[index].rawValue)")
                            .frame(width: 45, height: 45)
                            .overlay(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                        .stroke($notificationViewModel.time.wrappedValue.weeks[index] == true ? Color.blue : Color.white, lineWidth: 2))
                            
                    })
                    
                }
            }
            .padding()
            
            Spacer()
            Button(action: {
                notificationViewModel.setNotification()
            }, label: {
                Text("完成")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .overlay(RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.blue, lineWidth: 2))
                    .padding()
                    .alert(isPresented: $notificationViewModel.showAlert, content: {
                        Alert(title: Text($notificationViewModel.alert.type.wrappedValue.rawValue), message: Text($notificationViewModel.alert.message.wrappedValue), dismissButton: .default(Text("Ok")))
                    })
            })
            
        }
        
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
