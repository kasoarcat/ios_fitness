//
//  ContentView.swift
//  ios_fitness
//
//  Created by jakey on 2021/5/21.
//

import SwiftUI
import CoreData

struct GymDataView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \MySetting.weight, ascending: true)],
        animation: .default)
    private var items: FetchedResults<MySetting>
    
    var body: some View {
        VStack {
            Text("我的設定")
            List {
                ForEach(items) { item in
                    Text("Height: \(item.height) Weight: \(item.weight) Sex: \(item.sex ?? "無")")
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
            let newItem = MySetting(context: viewContext)
            let uuid = UUID()
            print(uuid)
            newItem.id = uuid
            newItem.height = 180
            newItem.weight = 90
            newItem.sex = "男"
            
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
//
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

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()


struct GymDataView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GymDataView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}