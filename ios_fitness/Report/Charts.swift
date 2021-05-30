//
//  Charts.swift
//  ios_fitness
//
//  Created by 喬彥翔 on 2021/5/23.
//

import SwiftUI
import SwiftUICharts
        
struct Charts: View {
    @Binding var date: Date
    var selectedDateRange = [("5/20",154),("5/21",45),("5/22",42),("5/23",563),("5/24",342),("5/25",245),("5/26",123)]
    var formatter: DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter
    }
    
    var body: some View {
        NavigationView{
            VStack (alignment: .leading, spacing: 50){
                BarChartView(data: ChartData(values: selectedDateRange), title: "卡路里消耗", legend: "date", form: ChartForm.extraLarge)
                
                Text("總消耗卡路里: ")
                    .font(.title)
                Text("7日內消耗卡路里: ")
                    .font(.title)
                let onlyDate = formatter.string(from: date)
                Text("選取日期: \(onlyDate)")
                
            }
            .offset(x: 0, y: -150)
            .padding()
            
        }
        
    }
}


struct Charts_Previews: PreviewProvider {
    static var previews: some View {
        Charts(date: .constant(Date()))
    }
    
}
