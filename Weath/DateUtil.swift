//
//  DateUtil.swift
//  Weath
//
//  Created by Marcus Johnson on 8/16/17.
//  Copyright © 2017 weather. All rights reserved.
//

import Foundation
extension Date {
    func getDateStringFromUnix(unix: Int)->String{
        let date = NSDate(timeIntervalSince1970:TimeInterval(unix))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM dd YYYY"
        return dayTimePeriodFormatter.string(from: date as Date)
    }
}
