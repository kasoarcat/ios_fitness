//
//  ContentView.swift
//  Body Tracking
//
//  Created by jakey on 2021/5/13.
//

import SwiftUI

struct TextView: UIViewRepresentable {
    class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
        
        init(_ text: Binding<String>) {
            self.text = text
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.text.wrappedValue = textView.text
        }
    }
    
    @Binding var text: String
    @Binding var textStyle: UIFont.TextStyle
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: textStyle)
        textView.autocapitalizationType = .sentences
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.delegate = context.coordinator
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.font = UIFont.preferredFont(forTextStyle: textStyle)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator($text)
    }
}


struct GymView: View {
    @State var amount: Int = 0
    @State private var message = ""
    @State private var textStyle = UIFont.TextStyle.body
    
    var body: some View {
        #if arch(arm64)
        ZStack {
            ARViewContainer()
                .edgesIgnoringSafeArea(.all)
        }
        #else
        VStack {
            Text("健身房")
//            ZStack(alignment: .topTrailing) {
//                TextView(text: $message, textStyle: $textStyle)
//                    .padding(.horizontal)
//                Button(action: {
//                    self.textStyle = (self.textStyle == .body) ? .title1 : .body
//                }) {
//                    Image(systemName: "textformat")
//                        .imageScale(.large)
//                        .frame(width: 40, height: 40)
//                        .foregroundColor(.white)
//                        .background(Color.purple)
//                        .clipShape(Circle())
//                }
//                .padding()
//            }
        }
        #endif
    }
}

struct GymView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GymView()
        }
    }
}
