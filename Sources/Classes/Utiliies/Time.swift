//
//  Time.swift
//  ExtAppKit-iOS
//
//  Created by Thomas Bonk on 02.12.18.
//  Copyright © 2018 Thomas Bonk Softwareentwicklung. All rights reserved.
//

import Foundation

open class Time: Hashable, Comparable {
    
    // MARK: - Properties
    
    public var hour: Int
    public var minute: Int
    public var second: Int
    public var millisecond: Int
    public var milliseconds: Int {
        return (hour * 60 * 60 * 1000)
            + (minute * 60 * 1000)
            + (second * 1000)
            + millisecond;
    }
    public var timeIntervall: TimeInterval {
        return Double((hour * 60 * 60)
            + (minute * 60)
            + second)
            + Double(millisecond) / 1000.0;
    }
    
    // MARK: - Initialization
    
    public init() {
        self.hour = 0
        self.minute = 0
        self.second = 0
        self.millisecond = 0
    }
    
    public init(hour: Int, minute: Int, second: Int = 0, millisecond: Int = 0) {
        self.hour = hour
        self.minute = minute
        self.second = second
        self.millisecond = millisecond
    }
    
    public convenience init(fromDate date: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)
        
        self.init(hour: components.hour!, minute: components.minute!, second: components.second!)
    }
    
    // MARK: - Calculation
    
    /// Returns a `Date` with a specified amount of time added to it.
    public static func + (lhs: Time, rhs: Time) -> Time {
        return Time(fromDate: ((Date().startOfDay + lhs.timeIntervall) + rhs.timeIntervall))
    }
    
    /// Returns a `Date` with a specified amount of time subtracted from it.
    public static func - (lhs: Time, rhs: Time) -> Time {
        return Time(fromDate: ((Date().startOfDay + lhs.timeIntervall) - rhs.timeIntervall))
    }
    
    /// Add a `TimeInterval` to a `Date`.
    ///
    /// - warning: This only adjusts an absolute value. If you wish to add calendrical concepts like hours, days, months then you must use a `Calendar`. That will take into account complexities like daylight saving time, months with different numbers of days, and more.
    public static func += (lhs: inout Time, rhs: Time) {
        lhs = lhs + rhs
    }
    
    /// Subtract a `TimeInterval` from a `Date`.
    ///
    /// - warning: This only adjusts an absolute value. If you wish to add calendrical concepts like hours, days, months then you must use a `Calendar`. That will take into account complexities like daylight saving time, months with different numbers of days, and more.
    public static func -= (lhs: inout Time, rhs: Time) {
        lhs = lhs - rhs
    }
    
    // MARK: - Comparable
        
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than that of the second argument.
    ///
    /// This function is the only requirement of the `Comparable` protocol. The
    /// remainder of the relational operator functions are implemented by the
    /// standard library for any type that conforms to `Comparable`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func < (lhs: Time, rhs: Time) -> Bool {
        return lhs.milliseconds < rhs.milliseconds
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than or equal to that of the second argument.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func <= (lhs: Time, rhs: Time) -> Bool {
        return lhs.milliseconds <= rhs.milliseconds
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is greater than or equal to that of the second argument.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func >= (lhs: Time, rhs: Time) -> Bool {
        return lhs.milliseconds >= rhs.milliseconds
    }
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is greater than that of the second argument.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func > (lhs: Time, rhs: Time) -> Bool {
        return lhs.milliseconds > rhs.milliseconds
    }
    
    public static func == (lhs: Time, rhs: Time) -> Bool {
        return lhs.milliseconds == rhs.milliseconds
    }
    
    // MARK: - Hashable
    
    /// The hash value.
    ///
    /// Hash values are not guaranteed to be equal across different executions of
    /// your program. Do not save hash values to use during a future execution.
    public var hashValue: Int {
        return milliseconds.hashValue
    }
    
    /// Hashes the essential components of this value by feeding them into the
    /// given hasher.
    ///
    /// Implement this method to conform to the `Hashable` protocol. The
    /// components used for hashing must be the same as the components compared
    /// in your type's `==` operator implementation. Call `hasher.combine(_:)`
    /// with each of these components.
    ///
    /// - Important: Never call `finalize()` on `hasher`. Doing so may become a
    ///   compile-time error in the future.
    ///
    /// - Parameter hasher: The hasher to use when combining the components
    ///   of this instance.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
    
}
