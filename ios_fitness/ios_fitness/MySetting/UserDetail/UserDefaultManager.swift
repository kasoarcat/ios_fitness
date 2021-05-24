//
//  UserDefaultManager.swift
//  ios_fitness
//
//  Created by 范桶 on 2021/5/25.
//
import SwiftUI
import UIKit

class UserDefaultManager: ObservableObject {
    @Published var height: Int = UserDefaults.standard.integer(forKey: "height") {
        didSet {
            UserDefaults.standard.set(self.height, forKey: "height")
        }
    }
    
    @Published var weight: Int = UserDefaults.standard.integer(forKey: "weight") {
        didSet {
            UserDefaults.standard.set(self.weight, forKey: "weight")
        }
    }
    
    @Published var gender: Int = UserDefaults.standard.integer(forKey: "gender") {
        didSet {
            UserDefaults.standard.set(self.gender, forKey: "gender")
        }
    }
}
