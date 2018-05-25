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
        if timeUntil < .oneHour * 6 {
            return shortCountdownString(with: timeUntil)
        } else {
            return longCountdownString(with: date)
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
    
    func longCountdownString(with date: Date) -> String {
        let components = Calendar.current.dateComponents([.day, .year, .month], from: Date(timeIntervalSinceNow: .oneDay))
        let tomorrowDate = Calendar.current.date(from: components) ?? .distantPast
        let timeString = DateFormatter.countdownTimeFormatter.string(from: date).lowercased()
        
        if date < tomorrowDate {
            // date is today
            return "Today at \(timeString)"
        } else if date < tomorrowDate.addingTimeInterval(.oneDay) {
            // date is tomorrow
            return "Tomorrow at \(timeString)"
        } else if date < tomorrowDate.addingTimeInterval(.oneDay * 6) {
            // date is this week
            let weekday = DateFormatter.weekdayFormatter.string(from: date)
            return "\(weekday) at \(timeString)"
        } else {
            let dateString = DateFormatter.longCountdownFormatter.string(from: date)
            return "\(dateString) at \(timeString)"
        }
    }
    
    func probabilityString(from probability: Double?) -> String {
        guard let probability = probability else { return "" }
        let percentage = Int(round(probability * 100.0))
        if percentage > 0 {
            return "\(percentage)% Go for launch"
        } else {
            return "No go"
        }
    }
}
