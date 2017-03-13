//
//  LaunchTextProvider.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/13/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import Foundation

struct LaunchTextProvider {
    
    func countdownString(from date: Date) -> String {
        let timeUntil = date.timeIntervalSinceNow
        if timeUntil < .oneDay * 2 {
            return shortCountdownString(with: timeUntil)
        } else {
            return longCountdownString(with: timeUntil)
        }
    }
    
    func shortCountdownString(with secondsUntil: TimeInterval) -> String {
        let hours = floor(secondsUntil / .oneHour)
        let minutes = floor((secondsUntil - hours * .oneHour) / .oneMinute)
        let seconds = floor(secondsUntil - (hours * .oneHour) - (minutes * .oneMinute))
        
        let hoursString = hours < 10 ? "0\(Int(hours))" : "\(Int(hours))"
        let minutesString = minutes < 10 ? "0\(Int(minutes))" : "\(Int(minutes))"
        let secondsString = seconds < 10 ? "0\(Int(seconds))" : "\(Int(seconds))"
        return "T- \(hoursString):\(minutesString):\(secondsString)"
    }
    
    func longCountdownString(with secondsUntil: TimeInterval) -> String {
        if secondsUntil > .oneWeek {
            let weeks = Int(secondsUntil / .oneWeek)
            return weeks == 1 ? "1 week" : "\(weeks) weeks"
        } else if secondsUntil > .oneDay {
            let days = Int(secondsUntil / .oneDay)
            return days == 1 ? "1 day" : "\(days) days"
        } else if secondsUntil > .oneHour {
            let hours = Int(secondsUntil / .oneHour)
            return hours == 1 ? "1 hour" : "\(hours) hours"
        } else if secondsUntil > .oneMinute {
            let minutes = Int(secondsUntil / .oneMinute)
            return minutes == 1 ? "1 minute" : "\(minutes) days"
        } else {
            let seconds = Int(secondsUntil)
            return seconds == 1 ? "1 second" : "\(seconds) seconds"
        }
    }
    
    func probabilityString(from probability: Double) -> String {
        let percentage = Int(round(probability * 100.0))
        if percentage > 0 {
            return "\(percentage)% Go for launch"
        } else if probability == 0 {
            return "No go"
        } else {
            // -1 means unknown
            return ""
        }
    }
}
