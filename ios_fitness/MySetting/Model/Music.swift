//
//  Music.swift
//  ios_fitness
//
//  Created by 范桶 on 2021/6/6.
//

import Foundation

struct Music {
    var enable: Bool
    var volume: Float
    var tempVolume: Float
    var selection: Int
    
    init(enable: Bool, volume: Float, selection: Int) {
        self.enable = enable
        self.volume = volume
        self.tempVolume = volume
        self.selection = selection
    }
}
