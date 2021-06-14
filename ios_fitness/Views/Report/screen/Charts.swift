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
    @FetchRequest(entity: Actions.entity(), sortDescriptors: [])
    var items: FetchedResults<Actions>
    
    @StateObject var date = DatePick()
    
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
    
    
    var firstDate: Date{
        return Calendar.current.date(byAdding: .day, value: -3, to: date.date)!}
    var secondDate: Date{
        return Calendar.current.date(byAdding: .day, value: -2, to: date.date)!}
    var thirdDate: Date{
        return Calendar.current.date(byAdding: .day, value: -1, to: date.date)!}
    var fifthDate: Date{
        return Calendar.current.date(byAdding: .day, value: +1, to: date.date)!}
    var sixthDate: Date{
        return Calendar.current.date(byAdding: .day, value: +2, to: date.date)!}
    var seventhDate: Date{
        return Calendar.current.date(byAdding: .day, value: +3, to: date.date)!}
    
    func matchingCal() -> [(String,Int)]{
        //        var oneDayCal = 0
        var firstCal: Int = 0
        var secondCal: Int = 0
        var thirdCal: Int = 0
        var selectCal: Int = 0
        var fifthCal: Int = 0
        var sixthCal: Int = 0
        var seventhCal: Int = 0
        
        for i in items{
            if DatePick().formatter.string(from: i.startDate!) == DatePick().formatter.string(from: firstDate){
                firstCal += Int(i.calories)
            }
            if DatePick().formatter.string(from: i.startDate!) == DatePick().formatter.string(from: secondDate){
                secondCal += Int(i.calories)
            }
            if DatePick().formatter.string(from: i.startDate!) == DatePick().formatter.string(from: thirdDate){
                thirdCal += Int(i.calories)
            }
            if DatePick().formatter.string(from: i.startDate!) == DatePick().formatter.string(from: date.date){
                selectCal += Int(i.calories)
            }
            if DatePick().formatter.string(from: i.startDate!) == DatePick().formatter.string(from: fifthDate){
                fifthCal += Int(i.calories)
            }
            if DatePick().formatter.string(from: i.startDate!) == DatePick().formatter.string(from: sixthDate){
                sixthCal += Int(i.calories)
            }
            if DatePick().formatter.string(from: i.startDate!) == DatePick().formatter.string(from: seventhDate){
                seventhCal += Int(i.calories)
            }
            
        }
        return[(DatePick().formatter.string(from: firstDate),firstCal)
               ,(DatePick().formatter.string(from: secondDate),secondCal)
               ,(DatePick().formatter.string(from: thirdDate),thirdCal)
               ,(DatePick().formatter.string(from: date.date),selectCal)
               ,(DatePick().formatter.string(from: fifthDate),fifthCal)
               ,(DatePick().formatter.string(from: sixthDate),sixthCal)
               ,(DatePick().formatter.string(from: seventhDate),seventhCal)
               ,("seven",firstCal+secondCal+thirdCal+selectCal+fifthCal+sixthCal+seventhCal)]
    }
    
    var resultList:[(String,Int)]{
        return matchingCal()
    }
//    func sevenDays() -> Int{
//        return matchingCal()[7].1
//    }
//    func removeLast() -> [(String,Int)]{
//        return matchingCal().dropLast()
//    }
    
    //    var selectedDate: String{
    //        date.formatter.string(from: date.date)
    //                                }
    //    var firstCal: Int = 0
    //    var secondCal: Int = 0
    //    var thirdCal: Int = 0
    //    var selectCal: Int = 0
    //    var fifthCal: Int = 0
    //    var sixthCal: Int = 0
    //    var seventhCal: Int = 0
    //
    
    //    func matchingCal(){
    ////        var oneDayCal = 0
    //        for i in items{
    //            if DatePick().formatter.string(from: i.startDate!) == DatePick().formatter.string(from: ChartData().firstDate){
    //                firstCal += Int(i.calories)
    //            }
    //            if DatePick().formatter.string(from: i.startDate!) == DatePick().formatter.string(from: secondDate){
    //                secondCal += Int(i.calories)
    //            }
    //            if DatePick().formatter.string(from: i.startDate!) == DatePick().formatter.string(from: thirdDate){
    //                thirdCal += Int(i.calories)
    //            }
    //            if DatePick().formatter.string(from: i.startDate!) == DatePick().formatter.string(from: date.date){
    //                selectCal += Int(i.calories)
    //            }
    //            if DatePick().formatter.string(from: i.startDate!) == DatePick().formatter.string(from: fifthDate){
    //                fifthCal += Int(i.calories)
    //            }
    //            if DatePick().formatter.string(from: i.startDate!) == DatePick().formatter.string(from: sixthDate){
    //                sixthCal += Int(i.calories)
    //            }
    //            if DatePick().formatter.string(from: i.startDate!) == DatePick().formatter.string(from: seventhDate){
    //                seventhCal += Int(i.calories)
    //            }
    //
    //        }
    ////        return oneDayCal
    //    }
    //
    
    
    
    
    
    //    var selectedDateRange: [(String,Int)]{
    //        let firstDate = Calendar.current.date(byAdding: .day, value: -3, to: date.date)!
    //        let secondDate = Calendar.current.date(byAdding: .day, value: -2, to: date.date)!
    //        let thirdDate = Calendar.current.date(byAdding: .day, value: -1, to: date.date)!
    //        let fifthDate = Calendar.current.date(byAdding: .day, value: 1, to: date.date)!
    //        let sixthDate = Calendar.current.date(byAdding: .day, value: 2, to: date.date)!
    //        let seventhDate = Calendar.current.date(byAdding: .day, value: 3, to: date.date)!
    //        let first = date.formatter.string(from:firstDate)
    //        let second = date.formatter.string(from:secondDate)
    //        let third = date.formatter.string(from:thirdDate)
    //        let fifth =  date.formatter.string(from:fifthDate)
    //        let sixth =  date.formatter.string(from:sixthDate)
    //        let seventh = date.formatter.string(from:seventhDate)
    //        return [(first,matchingCal(date: firstDate)),(second,matchingCal(date: secondDate)),(third,matchingCal(date: thirdDate)),(selectedDate,matchingCal(date: date.date)),(fifth,matchingCal(date: fifthDate)),(sixth,matchingCal(date: sixthDate)),(seventh,matchingCal(date: seventhDate))]
    //
    //        }
    
    
    
    //    var sevenDaysCal: Int{
    ////
    //        let firstDate = Calendar.current.date(byAdding: .day, value: -3, to: date.date)!
    //        let secondDate = Calendar.current.date(byAdding: .day, value: -2, to: date.date)!
    //        let thirdDate = Calendar.current.date(byAdding: .day, value: -1, to: date.date)!
    //        let fifthDate = Calendar.current.date(byAdding: .day, value: 1, to: date.date)!
    //        let sixthDate = Calendar.current.date(byAdding: .day, value: 2, to: date.date)!
    //        let seventhDate = Calendar.current.date(byAdding: .day, value: 3, to: date.date)!
    //        return matchingCal(date: firstDate) + matchingCal(date: secondDate) + matchingCal(date: thirdDate) + matchingCal(date: date.date) + matchingCal(date: fifthDate) +
    //            matchingCal(date: sixthDate) + matchingCal(date: seventhDate)
    //    }
    
    
    
    var body: some View {
        NavigationView{
            VStack (alignment: .leading, spacing: 50){
                BarChartView(data: ChartData(values: resultList.dropLast()), title: "卡路里消耗", legend: "date", form: ChartForm.extraLarge)
                
                Text("總消耗卡路里: \(totalCal)")
                    .font(.title)
                
                Text("7日內消耗卡路里: \(resultList[7].1)")
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
        Charts()
    }
    
}
