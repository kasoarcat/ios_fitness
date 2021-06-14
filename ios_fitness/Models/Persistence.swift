//
//  Persistence.swift
//  ios_fitness
//
//  Created by jakey on 2021/5/21.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let newItem = MySetting(context: viewContext)
        newItem.id = UUID()
        newItem.height = 100
        newItem.weight = 50
        newItem.sex = "女"
        
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd" //  HH:mm:ss
            return formatter
        }()
        
//        for m in 1...12 { // 月
//            for d in 1...28 { // 日
//                for _ in 0..<Int.random(in: 0...2) { // 每天運動次數
//                    let action = Actions(context: viewContext)
//                    action.id = UUID()
//                    action.count = Int16.random(in: 1...10)
//                    action.calories = Int32.random(in: 50...200) * Int32(action.count)
//                    action.startDate = formatter.date(from: "2020/\(m)/\(d)")
//                    action.endDate = formatter.date(from: "2020/\(m)/\(d)")
//
//                    let c = Int.random(in: 0..<ActionEnum.allCases.count)
//                    action.name = ActionEnum.allCases[c].rawValue
//                }
//            }
//        }
        
        for m in 1...6 { // 月
            for d in 1...28 { // 日
                for _ in 0..<Int.random(in: 0...5) { // 每天運動次數
                    let action = Actions(context: viewContext)
                    action.id = UUID()
                    action.count = Int16.random(in: 1...10)
                    action.calories = Int32.random(in: 50...200) * Int32(action.count)
                    action.startDate = formatter.date(from: "2021/\(m)/\(d)")
                    action.endDate = formatter.date(from: "2021/\(m)/\(d)")

                    let c = Int.random(in: 0..<ActionEnum.allCases.count)
                    action.name = ActionEnum.allCases[c].rawValue
                }
            }
        }
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ios_fitness")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
