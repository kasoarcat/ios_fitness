//
//  UserDefaultManager.swift
//  ios_fitness
//
//  Created by 范桶 on 2021/5/25.
//
import SwiftUI
import UIKit

class UserDefaultManager: ObservableObject {
    @Published var message: String = ""
    
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
    
    @Published var notificationHour: String = UserDefaults.standard.string(forKey: "notificationHour") ?? "12" {
        didSet {
            UserDefaults.standard.set(self.notificationHour, forKey: "notificationHour")
        }
    }
    
    @Published var notificationMinute: String = UserDefaults.standard.string(forKey: "notificationMinute") ?? "0" {
        didSet {
            UserDefaults.standard.set(self.notificationMinute, forKey: "notificationMinute")
        }
    }
    
    @Published var notificationMeridium: String = UserDefaults.standard.string(forKey: "notificationMeridium") ?? "AM" {
        didSet {
            UserDefaults.standard.set(self.notificationMeridium, forKey: "notificationMeridium")
        }
    }
    
    @Published var notificationWeek: [Bool] = UserDefaults.standard.array(forKey: "notificationWeek") as? [Bool] ?? [false, false, false, false, false, false, false] {
        didSet {
            UserDefaults.standard.set(self.notificationWeek, forKey: "notificationWeek")
        }
    }
    
    @Published var musicEnable: Bool = UserDefaults.standard.bool(forKey: "musicEnable") {
        didSet {
            UserDefaults.standard.set(self.musicEnable, forKey: "musicEnable")
        }
    }
    
    @Published var musicVolume: Float = UserDefaults.standard.float(forKey: "musicVolume") {
        didSet {
            UserDefaults.standard.set(self.musicVolume, forKey: "musicVolume")
        }
    }
    
    @Published var musicSelection: Int = UserDefaults.standard.integer(forKey: "musicSelection") {
        didSet {
            UserDefaults.standard.set(self.musicSelection, forKey: "musicSelection")
        }
    }
    
    @Published var ttsEnable: Bool = UserDefaults.standard.bool(forKey: "ttsEnable") {
        didSet {
            UserDefaults.standard.set(self.ttsEnable, forKey: "ttsEnable")
        }
    }
    
    @Published var ttsVolume: Float = UserDefaults.standard.float(forKey: "ttsVolume") {
        didSet {
            UserDefaults.standard.set(self.ttsVolume, forKey: "ttsVolume")
        }
    }
    
    @Published var soundEffectEnable: Bool = UserDefaults.standard.bool(forKey: "soundEffectEnable") {
        didSet {
            UserDefaults.standard.set(self.soundEffectEnable, forKey: "soundEffectEnable")
        }
    }
    
    @Published var soundEffectVolume: Float = UserDefaults.standard.float(forKey: "soundEffectVolume") {
        didSet {
            UserDefaults.standard.set(self.soundEffectVolume, forKey: "soundEffectVolume")
        }
    }
}

