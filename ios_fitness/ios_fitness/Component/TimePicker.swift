//
//  TimePicker.swift
//  ios_fitness
//
//  Created by 范桶 on 2021/5/25.
//

import SwiftUI

struct TimePicker: View {
    typealias Label = String
    typealias Time = String
    
    let data: [(Label, [String])]
    @Binding var selection: [String]
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                ForEach(0..<self.data.count) { column in
                    Picker(self.data[column].0, selection: self.$selection[column]) {
                        ForEach(0..<self.data[column].1.count) { row in
                            Text(verbatim: self.data[column].1[row])
                                .tag(self.data[column].1[row])
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: geometry.size.width / CGFloat(self.data.count), height: geometry.size.height)
                    .clipped()
                }
            }
        }
        .frame(height: 220)
    }
}

struct TimePicker_Previews: PreviewProvider {
    static var previews: some View {
        TimePicker(data: [
            ("0", Array(0...10).map { "\($0)" }),
            ("1", Array(20...40).map { "\($0)" }),
            ("2", Array(100...200).map { "\($0)" })
        ], selection: .constant(["1", "2", "2"]))
    }
}
