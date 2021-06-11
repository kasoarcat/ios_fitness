//
//  SoundSlider.swift
//  ios_fitness
//
//  Created by 范桶 on 2021/6/5.
//

import SwiftUI

struct SoundSlider: View {
    @Binding var enable: Bool
    @Binding var volume: Float
    
    var body: some View {
        HStack {
            Image(systemName: "speaker")
            Slider(value: $volume, in: 0.0...1.0)
                .disabled(!enable)
            Image(systemName: "speaker.3")
        }
    }
}

struct SoundSlider_Previews: PreviewProvider {
    static var previews: some View {
        SoundSlider(enable: .constant(true), volume: .constant(0.5))
            .previewLayout(.fixed(width: 375, height: 60))
            .padding()
    }
}
