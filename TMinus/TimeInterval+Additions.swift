//
//  TimeInterval+Additions.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/13/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import Foundation

extension TimeInterval {
    static var oneWeek: TimeInterval {
        return 604800 // 7 * 24 * 60 * 60
    }
    
    static var oneDay: TimeInterval {
        return 86400 // 24 * 60 * 60
    }
    
    static var oneHour: TimeInterval {
        return 3600 // 60 * 60
    }
    
    static var oneMinute: TimeInterval {
        return 60
    }
}
