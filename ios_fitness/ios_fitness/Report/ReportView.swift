//
//  ReportView.swift
//  ios_fitness
//
//  Created by jakey on 2021/5/19.
//

import SwiftUI

struct ReportView: View {
    var body: some View {
        VStack {
            Text("報告")
        }
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
