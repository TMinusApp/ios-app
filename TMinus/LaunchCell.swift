//
//  LaunchCell.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/11/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import UIKit

class LaunchCell: UITableViewCell {
    static var reuseID: String {
        return "LaunchCell"
    }
    
    @IBOutlet var rocketLabel: UILabel!
    @IBOutlet var missionLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var probabilityLabel: UILabel!
    private var timer: Timer?
    
    func configure(with launch: Launch) {
        rocketLabel.text = launch.rocketName
        missionLabel.text = launch.missionName
        probabilityLabel.text = probabilityString(from: launch.probability)
        
        configureTimeLabel(with: launch)
        scheduleTimerIfNecessary(for: launch)
    }
    
    //MARK: Private
    
    private func scheduleTimerIfNecessary(for launch: Launch) {
        let timeUntil = launch.startDate.timeIntervalSinceNow
        if timeUntil < .oneDay * 2 {
            timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] timer in
                self?.configureTimeLabel(with: launch)
            }
        } else {
            timer?.invalidate()
            timer = nil
        }
    }
    
    private func configureTimeLabel(with launch: Launch) {
        timeLabel.text = timeString(from: launch.startDate)
    }
    
    private func timeString(from date: Date) -> String {
        let timeUntil = date.timeIntervalSinceNow
        if timeUntil < .oneDay * 2 {
            return shortCountdownString(with: timeUntil)
        } else {
            return longCountdownString(with: timeUntil)
        }
    }
    
    private func shortCountdownString(with secondsUntil: TimeInterval) -> String {
        let hours = floor(secondsUntil / .oneHour)
        let minutes = floor((secondsUntil - hours * .oneHour) / .oneMinute)
        let seconds = floor(secondsUntil - (hours * .oneHour) - (minutes * .oneMinute))
        
        let hoursString = hours < 10 ? "0\(Int(hours))" : "\(Int(hours))"
        let minutesString = minutes < 10 ? "0\(Int(minutes))" : "\(Int(minutes))"
        let secondsString = seconds < 10 ? "0\(Int(seconds))" : "\(Int(seconds))"
        return "T- \(hoursString):\(minutesString):\(secondsString)"
    }
    
    private func longCountdownString(with secondsUntil: TimeInterval) -> String {
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
    
    private func probabilityString(from probability: Double) -> String {
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
