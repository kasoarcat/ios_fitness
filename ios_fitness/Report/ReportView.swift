//
//  ReportView.swift
//  ios_fitness
//
//  Created by jakey on 2021/5/19.
//

import SwiftUI
import CoreData

struct ReportView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    
    @StateObject var date = DatePick()
    
    
    @State private var inputCalories: String = "0"
    
    private func addItem() {
        withAnimation {
            let newItem = Actions(context: viewContext)
            let uuid = UUID()
            print(uuid)
            newItem.id = uuid
            newItem.calories = Int32(inputCalories) ?? 0
            newItem.startDate = date.date
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                NavigationLink(
                    destination: Charts(date: date),
                    label: {
                        Text("觀看趨勢圖")
                            .font(.system(size: 25))
                    })
                    .offset(x: 210, y: 0)
                    
                DatePicker("", selection: $date.date, displayedComponents: [.date])
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                    .border(Color.black, width: 10)
                    .background(Color.gray)
                    .accentColor(.orange)
                Text(date.formatter.string(from: date.date))
                
                Text("消耗卡路里: ")
                    .font(.system(size: 25))
                HStack {
                    
                    TextField("enter numbers: ", text: $inputCalories)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        addItem()
                        
                    }
                    , label: {
                        Text("add data")
                        
                    })
                }
                NavigationLink(destination: DataList(),
                               label: {
                                Text("Data List")
                                
                               })
                
            }
            .navigationTitle("訓練日期")
            .padding()
        }
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
