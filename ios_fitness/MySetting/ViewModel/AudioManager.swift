//
//  AudioManager.swift
//  ios_fitness
//
//  Created by 范桶 on 2021/6/5.
//

import Foundation
import AVFoundation

class AudioManager: ObservableObject {
    var audioPlayer: AVAudioPlayer?
//    private var isPlaying: Bool = false
    
    @Published var musicEnable: Bool = true
    @Published var soundEffectEnable: Bool = true
    @Published var musicVolume: Float = 1.0
    @Published var soundEffectVolume: Float = 1.0
    
    @Published var selectedMusic = 0
    
    func play() {
        
    }
    
    
}
