//
//  NotificationManager.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/13/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import Foundation
import UserNotifications
import RxSwift

struct NotificationManager {
    enum AuthStatus {
        case unknown, granted, denied
    }
    
    func authorize() -> Observable<AuthStatus> {
        return Observable.create { observer in
            observer.onNext(.unknown)
            
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                if let error = error {
                    observer.onError(error)
                } else if !granted {
                    observer.onNext(.denied)
                } else {
                    observer.onNext(.granted)
                }
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    func registerNotifications(for launches: [Launch]) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        for launch in launches {
            let date = launch.startDate.addingTimeInterval(-.oneHour)
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            
            let content = UNMutableNotificationContent()
            var title = launch.rocketName
            if let missionName = launch.missionName, !missionName.isEmpty {
                title = "\(title) - \(missionName)"
            }
            content.title = title
            content.body = "The launch window is scheduled to open in one hour."
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let identifier = identifierForLaunch(launch)
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                if let error = error {
                    print("error registering notification: \(error.localizedDescription)")
                }
            })
        }
    }
    
    private func identifierForLaunch(_ launch: Launch) -> String {
        let dateString = DateFormatter.apiISOFormatter.string(from: launch.startDate)
        return "\(launch.missionName ?? launch.rocketName).\(dateString)"
    }
}
