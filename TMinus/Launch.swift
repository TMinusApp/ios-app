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
    enum Status: Int {
        case unknown, green, red, success, failed
    }
    
    let id: Int
    let name: String
    let rocket: Rocket
    let missions: [Mission]
    /// The date the launch window opens.
    let windowOpenDate: Date
    /// The date the launch window closes. Some launches (such as those to the ISS) have an instantaneous launch window, which can cause this property to be the same as windowOpenDate.
    let windowCloseDate: Date
    /// Percentage between 0.0 - 1.0
    let probability: Double
    let status: Status
    let videoURLs: [URL]
    /// If this is true, the dates are not 100% certain
    let dateIsUncertain: Bool
    /// If this is true, the times are not 100% certain
    let timeIsUncertain: Bool
    let failReason: String?
    let holdReason: String?
    let hashtag: String?
    
    init?(json: JSON) {
        guard let id = json["id"].int,
            let name = json["name"].string,
            let rocket = Rocket(json: json["rocket"]),
            let windowOpenDate = json["isostart"].string.flatMap(Date.fromAPIISODateString),
            let windowCloseDate = json["isoend"].string.flatMap(Date.fromAPIISODateString),
            let probability = json["probability"].double.flatMap({ $0/100.0 }),
            let dateIsUncertain = json["tbddate"].int.flatMap({ $0 == 1 }),
            let timeIsUncertain = json["tbdtime"].int.flatMap({ $0 == 1 }) else { assertionFailure(); return nil }
        
        self.id = id
        self.name = name
        self.rocket = rocket
        self.missions = (json["missions"].array ?? []).flatMap { Mission(json: $0) }
        self.windowOpenDate = windowOpenDate
        self.windowCloseDate = windowCloseDate
        self.probability = probability
        self.status = json["status"].int.flatMap { Status(rawValue: $0) } ?? .unknown
        self.videoURLs = (json["vidURLs"].array ?? []).flatMap {
            $0.string.flatMap({ URL(string: $0) })
        }
        self.dateIsUncertain = dateIsUncertain
        self.timeIsUncertain = timeIsUncertain
        self.failReason = json["failreason"].string
        self.holdReason = json["holdreason"].string
        self.hashtag = json["hashtag"].string
    }
}

extension Launch: NotificationType {
    func makeNotificationRequest() -> UNNotificationRequest {
        let date = windowOpenDate.addingTimeInterval(-.oneHour)
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let content = UNMutableNotificationContent()
        content.title = name
        content.body = NSLocalizedString("The launch window is scheduled to open in one hour.", comment: "")
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        return UNNotificationRequest(identifier: "\(id)", content: content, trigger: trigger)
    }
}

extension Date {
    static func fromAPIISODateString(_ dateString: String) -> Date? {
        return DateFormatter.apiISOFormatter.date(from: dateString)
    }
}
