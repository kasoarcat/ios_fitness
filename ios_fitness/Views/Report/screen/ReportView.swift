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
    
    @FetchRequest(entity: Actions.entity(), sortDescriptors: [])
   
    private var items: FetchedResults<Actions>
    
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
    
    func matchingCal(date: Date) -> Int{
        var oneDayCal = 0
        for i in items{
            if DatePick().formatter.string(from: i.startDate!) == DatePick().formatter.string(from: date){
                oneDayCal += Int(i.calories)
            }
            
        }
        return oneDayCal
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
                    .cornerRadius(30)
                    .border(Color.gray, width: 5)
                    .background(Color.white)
                    
                    .accentColor(.red)
                Text(date.formatter.string(from: date.date))
                
                Text("消耗卡路里: \(matchingCal(date: date.date))")
                    .font(.system(size: 25))
//                HStack {
//
//                    TextField("enter numbers: ", text: $inputCalories)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                    Button(action: {
//                        addItem()
//
//                    }
//                    , label: {
//                        Text("add data")
//
//                    })
//                }
//                NavigationLink(destination: DataList(),
//                               label: {
//                                Text("Data List")
//                                
//                               })
                
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
