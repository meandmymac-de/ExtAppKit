//
//  Date+Timezone.swift
//  ExtAppKit-iOS
//
//  Created by Thomas Bonk on 09.12.18.
//  Copyright © 2018 Thomas Bonk Softwareentwicklung. All rights reserved.
//

import Foundation

public extension Date {
    func convertToLocalTime(fromTimeZone timeZoneAbbreviation: String) -> Date? {
        if let timeZone = TimeZone(abbreviation: timeZoneAbbreviation) {
            let targetOffset = TimeInterval(timeZone.secondsFromGMT(for: self))
            let localOffeset = TimeInterval(TimeZone.autoupdatingCurrent.secondsFromGMT(for: self))
            
            return self.addingTimeInterval(targetOffset - localOffeset)
        }
        
        return nil
    }
}
