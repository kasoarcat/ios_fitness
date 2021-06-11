//
//  SoundEffectView.swift
//  ios_fitness
//
//  Created by 范桶 on 2021/5/25.
//

import SwiftUI

struct SoundEffectView: View {
    @EnvironmentObject var audioManager: AudioManager
    
    var body: some View {
        VStack {
            Form {
                Section {
                    Toggle("音樂", isOn: $audioManager.music.enable)
                        .onChange(of: audioManager.music.enable, perform: { value in
                            audioManager.onMusicToggleChange()
                        })
                    HStack {
                        Text("選擇音樂")
                        Picker("", selection: $audioManager.music.selection) {
                            ForEach(audioManager.songs.indices) { index in
                                Text(audioManager.songs[index])
                            }
                        }
                        .navigationViewStyle(StackNavigationViewStyle())
                    }
                    SoundSlider(enable: $audioManager.music.enable, volume: $audioManager.music.volume)
                        .onChange(of: audioManager.music.volume, perform: { value in
                            audioManager.onMusicSliderChange()
                        })
                }
                Section {
                    Toggle("語音", isOn: $audioManager.textToSpeech.enable)
                        .onChange(of: audioManager.textToSpeech.enable, perform: { value in
                            audioManager.onTTSToggleChange()
                        })
                    SoundSlider(enable: $audioManager.textToSpeech.enable, volume: $audioManager.textToSpeech.volume)
                        .onChange(of: audioManager.textToSpeech.volume, perform: { value in
                            audioManager.onTTSSliderChange()
                        })
                    Button("Test") {
                        audioManager.playTTS(text: "測試", language: "zh-TW")
                    }
                }
                Section {
                    Toggle("音效", isOn: $audioManager.soundEffect.enable)
                        .onChange(of: audioManager.soundEffect.enable, perform: { value in
                            audioManager.onSoundToggleChange()
                        })
                    SoundSlider(enable: $audioManager.soundEffect.enable, volume: $audioManager.soundEffect.volume)
                        .onChange(of: audioManager.soundEffect.volume, perform: { value in
                            audioManager.onSoundSliderChange()
                        })
                    Button("Test") {
                        audioManager.playSoundEffect()
                    }
                }
            }
        }
        .navigationBarTitle("聲音&音樂", displayMode: .inline)
    }
}

struct SoundEffectView_Previews: PreviewProvider {
    static var previews: some View {
        SoundEffectView()
            .environmentObject(AudioManager())
    }
}

