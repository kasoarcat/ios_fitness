//
//  AudioManager.swift
//  ios_fitness
//
//  Created by 范桶 on 2021/6/5.
//

import Foundation
import AVFoundation

class AudioManager: ObservableObject {
    
    var audioEffectPlayer: AVAudioPlayer?
    var audioMusicPlayer: AVAudioPlayer?
    var userSetting: UserDefaultManager = UserDefaultManager()
    let speaker: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    var songs: [String] = ["UNICORN", "&Z"]
    @Published var musicIsPlaying: Bool = false
    @Published var music: Music = Music(enable: true, volume: 1.0, selection: 0)
    @Published var textToSpeech: TextToSpeech = TextToSpeech(enable: true, volume: 1.0)
    @Published var soundEffect: SoundEffect = SoundEffect(enable: true, volume: 1.0)
    
    init() {
        self.music.enable = userSetting.musicEnable
        self.music.volume = userSetting.musicVolume
        self.music.selection = userSetting.musicSelection
        self.textToSpeech.enable = userSetting.ttsEnable
        self.textToSpeech.volume = userSetting.ttsVolume
        self.soundEffect.enable = userSetting.soundEffectEnable
        self.soundEffect.volume = userSetting.soundEffectVolume
    }
    
    func onMusicToggleChange() {
        if music.enable {
            music.volume = music.tempVolume
        } else {
            music.tempVolume = music.volume
            music.volume = 0.0
        }
        userSetting.musicEnable = music.enable
        userSetting.musicVolume = music.volume
    }
    
    func onMusicSliderChange() {
        userSetting.musicVolume = music.volume
    }
    
    func onTTSToggleChange() {
        if textToSpeech.enable {
            textToSpeech.volume = textToSpeech.tempVolume
        } else {
            textToSpeech.tempVolume = textToSpeech.volume
            textToSpeech.volume = 0.0
        }
        userSetting.ttsEnable = textToSpeech.enable
        userSetting.ttsVolume = textToSpeech.volume
    }
    
    func onTTSSliderChange() {
        userSetting.ttsVolume = textToSpeech.volume
    }
    
    func onSoundToggleChange() {
        if soundEffect.enable {
            soundEffect.volume = soundEffect.tempVolume
        } else {
            soundEffect.tempVolume = soundEffect.volume
            soundEffect.volume = 0.0
        }
        userSetting.soundEffectEnable = soundEffect.enable
        userSetting.soundEffectVolume = soundEffect.volume
    }
    
    func onSoundSliderChange() {
        userSetting.soundEffectVolume = soundEffect.volume
    }
    
    func playMusic() {
        guard let url = Bundle.main.url(forResource: self.songs[self.music.selection], withExtension: "mp3") else {
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            audioMusicPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let audioPlayer = audioMusicPlayer else {
                return
            }
            
            audioPlayer.volume = music.volume
            audioPlayer.play()
            musicIsPlaying = true
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopMusic() {
        if let audioPlayer = audioMusicPlayer {
            audioPlayer.stop()
            musicIsPlaying = false
        }
    }
    
    // 講中文：zh-TW, 講英文：en-US
    func playTTS(text: String, language: String) {
        if speaker.isSpeaking {
            speaker.stopSpeaking(at: .immediate)
        } else {
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: language)
            utterance.rate = AVSpeechUtteranceDefaultSpeechRate
            utterance.volume = textToSpeech.volume
            DispatchQueue.main.async {
                self.speaker.speak(utterance)
            }
        }
    }
    
    func playSoundEffect() {
        guard let url = Bundle.main.url(forResource: "beep", withExtension: "wav") else {
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            audioEffectPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let audioPlayer = audioEffectPlayer else {
                return
            }
            
            audioPlayer.volume = soundEffect.volume
            audioPlayer.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
