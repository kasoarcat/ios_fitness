//
//  ContentView.swift
//  ios_fitness
//
//  Created by jakey on 2021/5/21.
//

import SwiftUI
import CoreData

extension Actions {
    static var dueSoonFetchRequest: NSFetchRequest<Actions> {
        let formatter: DateFormatter = {
    //        Actions.fetchResult(viewContext: viewContext)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd" //  HH:mm:ss
            return formatter
        }()
        
        let startDate = formatter.date(from: "2021/5/5")
        let endDate   = formatter.date(from: "2021/6/3")
        
        let request: NSFetchRequest<Actions> = Actions.fetchRequest()
//        request.predicate = NSPredicate(format: "count <= 5")
        request.predicate = NSPredicate(format: "endDate BETWEEN {%@, %@}", startDate! as CVarArg, endDate! as CVarArg)
        request.sortDescriptors = [NSSortDescriptor(key: "count", ascending: true)]
        
        return request
    }
    
    static func fetchResult2(startDateStr: String, endDateStr: String) -> NSFetchRequest<Actions> {
        let formatter: DateFormatter = {
    //        Actions.fetchResult(viewContext: viewContext)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd" //  HH:mm:ss
            return formatter
        }()
        
        let startDate = formatter.date(from: startDateStr)
        let endDate   = formatter.date(from: endDateStr)
        
        let request: NSFetchRequest<Actions> = Actions.fetchRequest()
//        request.predicate = NSPredicate(format: "count <= 5")
        request.predicate = NSPredicate(format: "endDate BETWEEN {%@, %@}", startDate! as CVarArg, endDate! as CVarArg)
        request.sortDescriptors = [NSSortDescriptor(key: "endDate", ascending: true)]
        
//        do {
//            let results = try viewContext.fetch(request) as [Actions]
//            print("results:", results)
//        }
//        catch let error as NSError {
//            print("Unresolved error \(error), \(error.userInfo)")
//        }
        return request
    }
    
    static func fetchResult(viewContext: NSManagedObjectContext) {
        let param = "endDate"
        let keyPathExp = NSExpression(forKeyPath: param) // can be any column
        let expression = NSExpression(forFunction: "count:", arguments: [keyPathExp])
        
        let desc = NSExpressionDescription()
        desc.expression = expression
        desc.name = "count"
        desc.expressionResultType = .integer64AttributeType
    
        let request: NSFetchRequest<NSFetchRequestResult> = Actions.fetchRequest()
//        request.sortDescriptors = [NSSortDescriptor(key: "count", ascending: true)]
        request.returnsObjectsAsFaults = false
        request.propertiesToGroupBy = [param]
        request.propertiesToFetch = [param, desc]
        request.resultType = .dictionaryResultType
        
//        request.predicate = NSPredicate(format:"\(param) contains[cd] %@", "aaa")
//        NSPredicate(format: "SUBQUERY(Actions, $entry, $entry.date BETWEEN {%@, %@}).@count > 0", dataController.week.startDate as CVarArg, dataController.week.endDate as CVarArg)
        
        do {
            let results = try viewContext.fetch(request) as! [Dictionary<String, NSObject>]
            print("results:", results)
        }
        catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
        
    }
}

struct ActionsDataView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Actions.endDate, ascending: true)],
//        predicate: NSPredicate(format: "count >= 5"),
////        predicate: NSPredicate(format: "name == %@", ActionEnum.開合跳.rawValue),
//        animation: .default)
//    private var items: FetchedResults<Actions>
    
//    @FetchRequest(fetchRequest: Actions.dueSoonFetchRequest)
    @FetchRequest(fetchRequest: Actions.fetchResult2(startDateStr: "2020/1/1", endDateStr: "2021/1/1"))
//    @FetchRequest(fetchRequest: Actions.myCount)
    private var items: FetchedResults<Actions>
    
//    let dict: [String: Int] = ["test1": 1, "test2": 2, "test3": 3]
    
    var body: some View {
//        let keys = dict.map{$0.key}
//        let values = dict.map {$0.value}
        
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd" //  HH:mm:ss
            return formatter
        }()
        
        VStack {
            Text("我的設定")
            List {
//                Text("a")
//                ForEach(keys.indices) { index in
//                    HStack {
//                        Text(keys[index])
//                        Text("\(values[index])")
//                    }
//                }
                
                ForEach(items) { item in
                    Text("date: \(formatter.string(from: item.endDate!)) c: \(item.count) \(item.name!)")
                }
                .onDelete(perform: deleteItems)
            }
            HStack {
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                        .foregroundColor(.green)
                }
                
                #if os(iOS)
                EditButton()
                    .foregroundColor(.red)
                #endif
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            let action = Actions(context: viewContext)
            action.id = UUID()
            action.count = 5

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
}

struct ActionsDataView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ActionsDataView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
