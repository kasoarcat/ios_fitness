//
//  Charts.swift
//  ios_fitness
//
//  Created by 喬彥翔 on 2021/5/23.
//

import SwiftUI
import SwiftUICharts
        
struct Charts: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject var date = DatePick()
    
//    var selectedDateRange = [("5/20",154),("5/21",45),("5/22",42),("5/23",563),("5/24",342),("5/25",245),("5/26",123)]
    
    @FetchRequest(entity: Actions.entity(), sortDescriptors: [])
    
    private var items: FetchedResults<Actions>
    
    var selectedDate: String{
        date.formatter.string(from: date.date)
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
        
    
//   var selectedDateRange: [(String,Int)]{
    
        
    var selectedDateRange: [(String,Int)]{
        let firstDate = Calendar.current.date(byAdding: .day, value: -3, to: date.date)!
        let secondDate = Calendar.current.date(byAdding: .day, value: -2, to: date.date)!
        let thirdDate = Calendar.current.date(byAdding: .day, value: -1, to: date.date)!
        let fifthDate = Calendar.current.date(byAdding: .day, value: 1, to: date.date)!
        let sixthDate = Calendar.current.date(byAdding: .day, value: 2, to: date.date)!
        let seventhDate = Calendar.current.date(byAdding: .day, value: 3, to: date.date)!
        let first = date.formatter.string(from:firstDate)
        let second = date.formatter.string(from:secondDate)
        let third = date.formatter.string(from:thirdDate)
        let fifth =  date.formatter.string(from:fifthDate)
        let sixth =  date.formatter.string(from:sixthDate)
        let seventh = date.formatter.string(from:seventhDate)
        return [(first,matchingCal(date: firstDate)),(second,matchingCal(date: secondDate)),(third,matchingCal(date: thirdDate)),(selectedDate,matchingCal(date: date.date)),(fifth,matchingCal(date: fifthDate)),(sixth,matchingCal(date: sixthDate)),(seventh,matchingCal(date: seventhDate))]
            
        }
    
    
    
    var sevenDaysCal: Int{
//
        let firstDate = Calendar.current.date(byAdding: .day, value: -3, to: date.date)!
        let secondDate = Calendar.current.date(byAdding: .day, value: -2, to: date.date)!
        let thirdDate = Calendar.current.date(byAdding: .day, value: -1, to: date.date)!
        let fifthDate = Calendar.current.date(byAdding: .day, value: 1, to: date.date)!
        let sixthDate = Calendar.current.date(byAdding: .day, value: 2, to: date.date)!
        let seventhDate = Calendar.current.date(byAdding: .day, value: 3, to: date.date)!
        return matchingCal(date: firstDate) + matchingCal(date: secondDate) + matchingCal(date: thirdDate) + matchingCal(date: date.date) + matchingCal(date: fifthDate) +
            matchingCal(date: sixthDate) + matchingCal(date: seventhDate)
    }
        
    
    var totalCal: Int{
        
        var totalCal = 0
        
        func caculateCal() -> Int{
            for i in items{
                totalCal += Int(i.calories)
            }
            return totalCal
        }
        return caculateCal()
    }
    
    
    var body: some View {
        NavigationView{
            VStack (alignment: .leading, spacing: 50){
                BarChartView(data: ChartData(values: selectedDateRange), title: "卡路里消耗", legend: "date", form: ChartForm.extraLarge)
                
                Text("總消耗卡路里: \(totalCal)")
                    .font(.title)
                
//                let sum =  list[0].1 + list[1].1 +  list[2].1 +  list[3].1 +  list[4].1 +  list[5].1 +
//                    list[6].1
                    
                Text("7日內消耗卡路里: \(sevenDaysCal)")
                    .font(.title)
                let onlyDate = date.formatter.string(from: date.date)
                Text("選取日期: \(onlyDate)")
                
            }
            .offset(x: 0, y: -150)
            .padding()
            
        }
        
    }
}


struct Charts_Previews: PreviewProvider {
    static var previews: some View {
        Charts(date: DatePick())
    }
    
}
