//
//  ContentView.swift
//  ios_fitness
//
//  Created by jakey on 2021/5/21.
//

import SwiftUI
import CoreData

struct MySettingView: View {
//    @Environment(\.managedObjectContext) private var viewContext
    var body: some View {

        NavigationView {
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 0) {
                Form {
                    NavigationLink(destination: UserDetailView()) {
                        SettingFormRow(icon: "person", text: "關於我")
                    }
                    NavigationLink(destination: NotificationView()) {
                        SettingFormRow(icon: "clock", text: "提醒")
                    }
                    NavigationLink(destination: SoundEffectView()) {
                        SettingFormRow(icon: "speaker.wave.3", text: "音效＆音樂")
                    }


                }
            }
            .navigationBarTitle("個人檔案", displayMode: .inline)
        }
//        VStack(alignment: .leading) {
//            Text("設定")
//                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
//            List {
//                ForEach(items) { item in
//                    Text("Height: \(item.height) Weight: \(item.weight) Sex: \(item.sex ?? "無")")
//                }
//                .onDelete(perform: deleteItems)
//            }
//            HStack {
//                Button(action: addItem) {
////                Button(action: addItem) {
//                    Label("Add Item", systemImage: "plus")
//                        .foregroundColor(.green)
//                }
//                #if os(iOS)
//                EditButton()
//                    .foregroundColor(.red)
//                #endif
//            }
//        }
//        .padding()
    }
    
//    private func addItem() {
//        withAnimation {
//            let newItem = MySetting(context: viewContext)
//            let uuid = UUID()
//            print(uuid)
//            newItem.id = uuid
//            newItem.height = 180
//            newItem.weight = 90
//            newItem.sex = "男"
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
    
}

//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
//    return formatter
//}()


struct MySettingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MySettingView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}

