//
//  TextToSpeech.swift
//  ios_fitness
//
//  Created by 范桶 on 2021/6/6.
//

import Foundation

struct TextToSpeech {
    var enable: Bool
    var volume: Float
    var tempVolume: Float
    
    init(enable: Bool, volume: Float) {
        self.enable = enable
        self.volume = volume
        self.tempVolume = volume
    }
}
