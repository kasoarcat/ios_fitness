//
//  SoundEffectView.swift
//  ios_fitness
//
//  Created by 范桶 on 2021/5/25.
//

import SwiftUI

struct SoundEffectView: View {
    @ObservedObject var audioManager = AudioManager()
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        Toggle("音樂", isOn: $audioManager.musicEnable)
                        HStack {
                            Text("選擇音樂")
                            Picker("", selection: $audioManager.selectedMusic) {
                                ForEach(60..<250, id: \.self) { number in
                                    Text(String(number))
                                }
                            }
                        }
                        SoundSlider(enable: audioManager.musicEnable, volume: audioManager.musicVolume)
                    }
                    Section {
                        Toggle("語音", isOn: $audioManager.soundEffectEnable)
                        SoundSlider(enable: audioManager.soundEffectEnable, volume: audioManager.soundEffectVolume)
                    }
                }
            }
            .navigationBarTitle("聲音&音樂", displayMode: .inline)
        }
        
    }
}

struct SoundEffectView_Previews: PreviewProvider {
    static var previews: some View {
        SoundEffectView()
    }
}

