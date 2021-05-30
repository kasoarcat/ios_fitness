//
//  ReportView.swift
//  ios_fitness
//
//  Created by jakey on 2021/5/19.
//

import SwiftUI
import CoreData

struct ReportView: View {
    
    @State var date = Date()
    var calories: Int = 1
    var body: some View {
    NavigationView {
        VStack(alignment: .leading, spacing: 50) {
                NavigationLink(
                    destination: Charts(date: $date),
                    label: {
                        Text("觀看趨勢圖")
                            .font(.system(size: 25))
                            
                    })
                    .padding()
                    .offset(x: 200, y: 50)
                DatePicker("", selection: $date, displayedComponents: [.date])
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                    .border(Color.black, width: 10)
                    .background(Color.gray)
                    .accentColor(.orange)
                    
            Text("消耗卡路里: \(calories)")
                    .font(.system(size: 25))
            }
            .padding()
            .offset(x: 0, y: -100)
            .navigationTitle("訓練日期")
        
        }
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
             ReportView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
