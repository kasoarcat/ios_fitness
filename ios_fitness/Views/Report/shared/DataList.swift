//
//  DataList.swift
//  ios_fitness
//
//  Created by Joechiao on 2021/6/2.
//

import SwiftUI

struct DataList: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Actions.calories, ascending: true)],
//        animation: .default)
    @FetchRequest(entity: Actions.entity(), sortDescriptors: [])
   
    private var items: FetchedResults<Actions>
    
    @StateObject var date = DatePick()
    
    var body: some View {
        List{
            ForEach(items){ items in
                HStack{
                    VStack(alignment: .leading){
                        Text("\(date.formatter.string(from: items.startDate!)) - \(String(items.calories))")
                }
                
            }
        }
    }
}

struct DataList_Previews: PreviewProvider {
    static var previews: some View {
        DataList()
    }
}
}
