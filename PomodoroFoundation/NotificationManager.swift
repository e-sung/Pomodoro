//
//  NotificationManager.swift
//  PomodoroFoundation
//
//  Created by 류성두 on 29/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import Foundation
import UserNotifications

public class NotificationManager {
    
    public init(delegate: UNUserNotificationCenterDelegate) {
        let notiCenter = UNUserNotificationCenter.current()
        notiCenter.delegate = delegate
        notiCenter.requestAuthorization(options: [.alert, .sound],
                                        completionHandler: {(granted, error) in
                                            PermissionManager.shared.canSendLocalNotification = granted
        })
    }

    public func publishNotiContent(of interval: Interval, via notiCenter: UNUserNotificationCenter) {
        clearPendingNotifications(on: notiCenter)
        add(notiAction: interval.notiAction, for: interval.notiContent, to: notiCenter)
        if PermissionManager.shared.canSendLocalNotification {
            // TODO: meaningful identifier
            let request = UNNotificationRequest(identifier: Date().debugDescription,
                                                content: interval.notiContent,
                                                trigger: nil)
            notiCenter.add(request) { (error) in
                if let error = error{
                    print("Error posting notification:\(error.localizedDescription)")
                }
            }
        }
    }
    
    func clearPendingNotifications(on notiCenter: UNUserNotificationCenter) {
        notiCenter.removeAllPendingNotificationRequests()
        notiCenter.removeAllDeliveredNotifications()
    }
    
    func add(notiAction: UNNotificationAction, for notiContent: UNNotificationContent, to notiCenter: UNUserNotificationCenter) {
        let timerCategory = UNNotificationCategory(identifier: notiContent.categoryIdentifier,
                                                   actions: [notiAction], intentIdentifiers: [], options: [])
        notiCenter.setNotificationCategories([timerCategory])
    }
}
