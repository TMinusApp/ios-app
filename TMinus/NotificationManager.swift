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

enum NotificationAuthStatus {
    case unknown, granted, denied
}

struct NotificationManager<T: NotificationType> {

    func removePendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func registerNotifications(for models: [T]) {
        models.forEach { self.registerNotification(for: $0) }
    }
    
    func registerNotification(for model: T) {
        let request = model.makeNotificationRequest()
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            if let error = error {
                print("error registering notification: \(error.localizedDescription)")
            }
        })
    }
}

//MARK: Rx Extensions

extension NotificationManager {
    
    func checkAuthStatus() -> Observable<NotificationAuthStatus> {
        return Observable.create { observer in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .notDetermined,
                     .denied:
                    observer.onNext(.denied)
                case .authorized:
                    observer.onNext(.granted)
                }
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    func authorize() -> Observable<NotificationAuthStatus> {
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
}

extension NotificationManager: ObserverType {
    typealias E = T
    
    func on(_ event: Event<T>) {
        switch event {
        case .next(let model):
            registerNotification(for: model)
        default:
            break
        }
    }
}
