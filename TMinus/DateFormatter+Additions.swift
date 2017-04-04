//
//  DateFormatter+Additions.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/11/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import Foundation

fileprivate var formatters = [String:DateFormatter]()

extension DateFormatter {
    static var apiFormatter: DateFormatter {
        return getDateFormatter(with: "y-MM-dd")
    }
    
    static var apiISOFormatter: DateFormatter {
        return getDateFormatter(with: "yyyyMMdd'T'HHmmss'Z'",
                                locale: Locale(identifier: "en_US_POSIX"),
                                timeZone: TimeZone(secondsFromGMT: 0) ?? TimeZone.current)
    }
    
    static var countdownTimeFormatter: DateFormatter {
        return getDateFormatter(with: "h:mma") // 5:45PM
    }
    
    static var weekdayFormatter: DateFormatter {
        return getDateFormatter(with: "cccc") // Tuesday
    }
    
    static var longCountdownFormatter: DateFormatter {
        return getDateFormatter(with: "ccc, LLL dd") // Tues, Sept 12
    }
    
    //MARK: Private
    
    private static func getDateFormatter(with format: String, locale: Locale = Locale.current, timeZone: TimeZone = TimeZone.current) -> DateFormatter {
        if let formatter = formatters[format] {
            return formatter
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.locale = locale
            formatter.timeZone = timeZone
            formatters[format] = formatter
            return formatter
        }
    }
}
