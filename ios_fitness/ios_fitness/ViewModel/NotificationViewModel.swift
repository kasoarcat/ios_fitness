//
//  NotificationManager.swift
//  ios_fitness
//
//  Created by 范桶 on 2021/5/25.
//

import Foundation
import UIKit
import UserNotifications

class NotificationViewModel: ObservableObject {
    var userDefaultManager: UserDefaultManager = UserDefaultManager()
    @Published var time =  AlarmTime(hour: "12", minute: "0", meridium: "上午")
    @Published var alert = AlertOption(type: .none, message: "")
    @Published var showAlert: Bool = false
    @Published var alarmIsSet: Bool = false
    @Published var selection: [String]
    
    private let center = UNUserNotificationCenter.current()
    
    init() {
        selection = [userDefaultManager.notificationMeridium, userDefaultManager.notificationHour, userDefaultManager.notificationMinute]
        time.weeks = userDefaultManager.notificationWeek
        print(selection)
        center.requestAuthorization(options: [.alert, .sound, .badge]) { permissionGranted, error in
            DispatchQueue.main.async {
                
                guard permissionGranted else {
                    return
                }
                
            }
        }
    }
    
    func setNotification() {
        center.removeAllPendingNotificationRequests()
        setTimeBySelection()
        scheduleNotifications()
    }
    
    private func setTimeBySelection() {
        time.meridium = selection[0]
        userDefaultManager.notificationMeridium = selection[0]
        time.hour = selection[1]
        userDefaultManager.notificationHour = selection[1]
        time.minute = selection[2]
        userDefaultManager.notificationMinute = selection[2]
        userDefaultManager.notificationWeek = time.weeks
        print(time.weeks)
        print(selection)
    }
    
    private func scheduleNotifications() {
        var count: Int = 0
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                guard (settings.authorizationStatus == .authorized) || (settings.authorizationStatus == .provisional) else { return }
                for index in 0..<7 {
                    if self.time.weeks[index] {
                        let content = UNMutableNotificationContent()
                        content.title = "Alarm"
                        content.body = "起來摟"
                        content.sound = .default
                        
                        var dateComponents = DateComponents()
                        dateComponents.hour = (self.time.meridium == "上午") ? Int(self.time.hour) : (Int(self.time.hour) ?? 0) + 12
                        dateComponents.minute = Int(self.time.minute)
                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                        self.center.add(request)
                    } else {
                        // 計算沒有選的數量
                        count = count + 1
                    }
                }
                
                if count == 7 {
                    self.alert = AlertOption(type: .error, message: "請選擇星期")
                    self.showAlert = true
                } else {
                    self.alert = AlertOption(type: .success, message: "提醒設定完成")
                    self.showAlert = true
                    self.alarmIsSet = true
                }
            }
        }
    }
    
    func setWeek(_ index: Int) {
        if time.weeks[index] {
            time.weeks[index] = false
        } else {
            time.weeks[index] = true
        }
        
    }
}
