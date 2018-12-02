//
//  NSDate+StripDate.swift
//  ExtAppKit
//
//  Created by Thomas Bonk on 01.02.16.
//  Copyright © 2016 Thomas Bonk Softwareentwicklung / meandmymac.de. All rights reserved.
//

import Foundation

/**
    Useful extensions to the NSDate class.
 */
public extension Date {
    /**
        Returns the given date without the time components.

        :param: date    The date

        :returns: The given date without the date components.
     */
    public static func time(_ date: Date? = nil) -> Time {
        enter()

        let d = date == nil ? Date() : date!
        let time = Time(fromDate: d)

        defer {
            leave()
        }
        return time
    }

    /**
     Returns the date without the time components.

     :returns: The date without the time components.
     */
    public func time() -> Time {
        enter()
        defer {
            leave()
        }
        return Date.time(self)
    }

}
