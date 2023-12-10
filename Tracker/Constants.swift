//
//  Constants.swift
//  Tracker
//
//  Created by Ramilia on 19/11/23.
//

import Foundation

let ypFontMedium = "YSDisplay-Medium"
let ypFontBold = "YSDisplay-Bold"
//
//extension Date {
//    func dayNumberOfWeek() -> Int? {
//        return Calendar.current.dateComponents([.weekday], from: self).weekday
//    }
//}
extension Date {
    
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
    func dayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}
