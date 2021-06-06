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
    let speaker: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
//    @Published var selectedMusic = 0
    @Published var music: Music = Music(enable: true, volume: 1.0, selection: 0)
    @Published var textToSpeech: TextToSpeech = TextToSpeech(enable: true, volume: 1.0)
    @Published var soundEffect: SoundEffect = SoundEffect(enable: true, volume: 1.0)
    
    func onMusicToggleChange() {
        if music.enable {
            music.volume = music.tempVolume
        } else {
            music.tempVolume = music.volume
            music.volume = 0.0
        }
    }
    
    func onTTSToggleChange() {
        if textToSpeech.enable {
            textToSpeech.volume = textToSpeech.tempVolume
        } else {
            textToSpeech.tempVolume = textToSpeech.volume
            textToSpeech.volume = 0.0
        }
    }
    
    func onSoundToggleChange() {
        if soundEffect.enable {
            soundEffect.volume = soundEffect.tempVolume
        } else {
            soundEffect.tempVolume = soundEffect.volume
            soundEffect.volume = 0.0
        }
    }
    
    func playTTS(text: String) {
        if speaker.isSpeaking {
            speaker.stopSpeaking(at: .immediate)
        } else {
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
            utterance.volume = textToSpeech.volume
            DispatchQueue.main.async {
                self.speaker.speak(utterance)
            }
        }
    }
    
    func playSoundEffect() {
        guard let url = Bundle.main.url(forResource: "SoundEffect", withExtension: "mp3") else {
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let audioPlayer = audioPlayer else {
                return
            }
            
            audioPlayer.volume = soundEffect.volume
            audioPlayer.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
