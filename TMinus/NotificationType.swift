//
//  NotificationType.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/17/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import UserNotifications

protocol NotificationType {
    func makeNotificationRequest() -> UNNotificationRequest
}
