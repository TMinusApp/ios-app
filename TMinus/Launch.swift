//
//  Launch.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/12/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import Foundation
import UserNotifications

struct LaunchResponse: Codable {
    let total: Int
    let launches: [Launch]
}

struct Launch: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case rocket
        case missions
        case windowOpenDate = "isostart"
        case windowCloseDate = "isoend"
        case probability
        case status
        case videoURLs = "vidURLs"
        case dateIsUncertain = "tbddate"
        case timeIsUncertain = "tbdtime"
        case failReason = "failreason"
        case holdReason = "holdreason"
        case hashtag
        case location
    }
    
    enum Status: Int, Codable {
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
    let probability: Double?
    let status: Status
    let videoURLs: [URL]
    /// If this is true, the dates are not 100% certain
    let dateIsUncertain: Int
    /// If this is true, the times are not 100% certain
    let timeIsUncertain: Int
    let failReason: String?
    let holdReason: String?
    let hashtag: String?
    let location: Location
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

extension LaunchResponse: JSONDecodingStrategyProviding {
    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? {
        return .formatted(.apiISOFormatter)
    }
}
