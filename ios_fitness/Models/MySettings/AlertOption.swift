//
//  AlertOption.swift
//  ios_fitness
//
//  Created by 范桶 on 2021/5/25.
//

import Foundation

struct AlertOption {
    let id = UUID()
    var type: AlertType = .none
    var message: String
}

enum AlertType: String {
    case error = "error"
    case success = "success"
    case none = ""
}

