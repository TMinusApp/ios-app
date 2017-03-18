//
//  Launch.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/12/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import Foundation
import SwiftyJSON
import UserNotifications

struct Launch: JSONModel {
    let rocketName: String
    let missionName: String?
    let startDate: Date
    let probability: Double // percentage between 0.0 - 1.0
    
    init?(json: JSON) {
        guard let rocketName = json["rocket"]["name"].string,
            let startDate = json["isostart"].string.flatMap(Date.fromAPIISODateString),
            let probability = json["probability"].double.flatMap({ $0/100.0 }) else { return nil }
        
        self.rocketName = rocketName
        self.missionName = json["missions"][0]["name"].string
        self.startDate = startDate
        self.probability = probability
    }
    
    //MARK: Private
}

extension Launch: NotificationType {
    
    func makeNotificationRequest() -> UNNotificationRequest {
        let date = startDate.addingTimeInterval(-.oneHour)
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let content = UNMutableNotificationContent()
        var title = rocketName
        if let missionName = missionName, !missionName.isEmpty {
            title = "\(title) - \(missionName)"
        }
        content.title = title
        content.body = "The launch window is scheduled to open in one hour."
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let identifier = launchIdentifier()
        return UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    }
    
    private func launchIdentifier() -> String {
        let dateString = DateFormatter.apiISOFormatter.string(from: startDate)
        return "\(missionName ?? rocketName).\(dateString)"
    }
}

extension Date {
    static func fromAPIISODateString(_ dateString: String) -> Date? {
        return DateFormatter.apiISOFormatter.date(from: dateString)
    }
}
