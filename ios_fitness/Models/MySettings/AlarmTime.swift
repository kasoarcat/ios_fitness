//
//  AlarmTime.swift
//  ios_fitness
//
//  Created by 范桶 on 2021/5/25.
//

import Foundation
struct AlarmTime: Identifiable {
    let id: String = "alarm"
    var hour: String = ""
    var minute: String = ""
    var meridium: String = ""
    var weeks: [Bool] = []
}

