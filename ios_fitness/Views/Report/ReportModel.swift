//
//  ReportModel.swift
//  ios_fitness
//
//  Created by Joechiao on 2021/6/2.
//

import Foundation

class DatePick:ObservableObject{
    @Published var date = Date()
    
    var formatter: DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter
    }
    
}

