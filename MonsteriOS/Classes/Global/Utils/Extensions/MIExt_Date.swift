//
//  MIExt_Date.swift
//  MonsteriOS
//
//  Created by Rakesh on 03/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

extension Date {
    
    func getStringWithFormat(format:String) -> String {
           
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format
            return dateFormatter.string(from: self)

    }
    
    func compareWithDate(date:Date) -> ComparisonResult {
        
        if self.compare(date) == .orderedSame {
            return .orderedSame
        }else if self.compare(date) == .orderedDescending {
            return .orderedDescending
        }else {
            return .orderedAscending
        }
        
    }
    
    func getDaysDifferenceBetweenDatesWithComponents(toDate:Date) -> Int {
        
        let calendar = Calendar.current
        let component =  calendar.dateComponents([.day], from: self, to: toDate)
        
        return component.day!
    }
    func getCurrentMonthNumber()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        let nameOfMonth = dateFormatter.string(from: self)
        return nameOfMonth
    }
    func getCurrentYear()->Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let year = Int(dateFormatter.string(from: self)) ?? 0
        return year
    }
    func getSecondDifferenceBetweenDates() -> Int {
        return Int(Date().timeIntervalSince(self))
    }
    func getDateWithOutTime() -> Date{
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
            fatalError("Failed to strip time from Date object")
        }
        return date
    }
}

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

extension String {
    
    func dateWith(_ format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}

 extension Date {
    
    public func plus(seconds s: Int) -> Date {
        return self.addComponentsToDate(seconds: s, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func minus(seconds s: Int) -> Date {
        return self.addComponentsToDate(seconds: -s, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func plus(minutes m: Int) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: m, hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func minus(minutes m: Int) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: -m, hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func plus(hours h: Int) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: h, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func minus(hours h: Int) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: -h, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func plus(days d: Int) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: d, weeks: 0, months: 0, years: 0)
    }
    
    public func minus(days d: Int) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: -d, weeks: 0, months: 0, years: 0)
    }
    
    public func plus(weeks w: Int) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: w, months: 0, years: 0)
    }
    
    public func minus(weeks w: Int) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: -w, months: 0, years: 0)
    }
    
    public func plus(months m: Int) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: m, years: 0)
    }
    
    public func minus(months m: Int) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: -m, years: 0)
    }
    
    public func plus(years y: Int) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: y)
    }
    
    public func minus(years y: Int) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: -y)
    }
    
    private func addComponentsToDate(seconds sec: Int, minutes min: Int, hours hrs: Int, days d: Int, weeks wks: Int, months mts: Int, years yrs: Int) -> Date {
        var dc = DateComponents()
        dc.second = sec
        dc.minute = min
        dc.hour = hrs
        dc.day = d
        dc.weekOfYear = wks
        dc.month = mts
        dc.year = yrs
        return Calendar.current.date(byAdding: dc, to: self)!
    }
    
    public func midnightUTCDate() -> Date {
        var dc: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self)
        dc.hour = 0
        dc.minute = 0
        dc.second = 0
        dc.nanosecond = 0
        dc.timeZone = TimeZone(secondsFromGMT: 0)
        return Calendar.current.date(from: dc)!
    }
    
    public static func secondsBetween(date1 d1:Date, date2 d2:Date) -> Int {
        let dc = Calendar.current.dateComponents([.second], from: d1, to: d2)
        return dc.second!
    }
    
    public static func minutesBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.minute], from: d1, to: d2)
        return dc.minute!
    }
    
    public static func hoursBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.hour], from: d1, to: d2)
        return dc.hour!
    }
    
    public static func daysBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.day], from: d1, to: d2)
        return dc.day!
    }
    
    public static func weeksBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.weekOfYear], from: d1, to: d2)
        return dc.weekOfYear!
    }
    
    public static func monthsBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.month], from: d1, to: d2)
        return dc.month!
    }
    
    public static func yearsBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = Calendar.current.dateComponents([.year], from: d1, to: d2)
        return dc.year!
    }
    
    //MARK- Comparison Methods
    
    public func isGreaterThan(_ date: Date) -> Bool {
        return (self.compare(date) == .orderedDescending)
    }
    
    public func isLessThan(_ date: Date) -> Bool {
        return (self.compare(date) == .orderedAscending)
    }
    
    public func isEqual(_ date: Date) -> Bool {
        return (self.compare(date) == .orderedSame)
    }
    //MARK- Computed Properties
    
    public var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    public var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    public var month: Int {
        return NSCalendar.current.component(.month, from: self)
    }
    
    public var year: Int {
        return NSCalendar.current.component(.year, from: self)
    }
    
    public var hour: Int {
        return NSCalendar.current.component(.hour, from: self)
    }
    
    public var minute: Int {
        return NSCalendar.current.component(.minute, from: self)
    }
    
    public var second: Int {
        return NSCalendar.current.component(.second, from: self)
    }

}



extension Date {
    static var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date().noon)!
    }
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    var startOfNextWeek:Date?{
        return Calendar.current.date(byAdding: DateComponents(day: -1, weekOfYear: 1), to: Date())
    }
    var endOfNextWeek:Date?{
        return Calendar.current.date(byAdding: DateComponents(day: 7), to: startOfNextWeek!)
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    func getThisMonthEnd() -> Date? {
        let components:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month += 1
        components.day = 1
        components.day -= 1
        return Calendar.current.date(from: components as DateComponents)!
    }

    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
}


extension Calendar {
    static let iso8601 = Calendar(identifier: .iso8601)
}
extension Date {
    var startOfWeek: Date {
        return Calendar.iso8601.date(from: Calendar.iso8601.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }
    var daysOfWeek: [Date] {
        let startOfWeek = self.startOfWeek
        return (0...6).compactMap{ Calendar.current.date(byAdding: .day, value: $0, to: startOfWeek)}
    }
}
