//
//  NSDate+StripTime.swift
//  ExtAppKit
//
//  Created by Thomas Bonk on 27.11.14.
//  Copyright (c) 2014 Thomas Bonk Softwareentwicklung / meandmymac.de. All rights reserved.
//

import Foundation


/**
    Useful extensions to the NSDate class.
*/
public extension Date {
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        
        components.day = 1
        components.second = -1
        
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    /**
        Returns the given date without the time components.

        :param: date    The date

        :returns: The given date without the time components.
    */
    public static func dateWithoutTime(_ date: Date? = nil) -> Date {
        enter()

        let d = date == nil ? Date() : date!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: d)
        let dateWithoutTime = components.date

        defer {
            leave()
        }
        return dateWithoutTime!
    }

    /**
        Returns the date without the time components.

        :returns: The date without the time components.
    */
    public func dateWithoutTime() -> Date {
        enter()
        defer {
            leave()
        }
        return Date.dateWithoutTime(self)
    }

    /**
        Checks whether the receiver's date is equal to today.
    
        :returns: true if the reciver's date is today, otherwise false
    */
    public func isEqualToToday() -> Bool {
        enter()

        let result = self.dateWithoutTime() == Date().dateWithoutTime()

        defer {
            leave()
        }
        return result
    }
}
