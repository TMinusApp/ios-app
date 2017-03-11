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
    
    //MARK: Private
    
    private static func getDateFormatter(with format: String) -> DateFormatter {
        if let formatter = formatters[format] {
            return formatter
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatters[format] = formatter
            return formatter
        }
    }
}
