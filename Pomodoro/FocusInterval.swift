//
//  FocusInterval.swift
//  Pomodoro
//
//  Created by 류성두 on 23/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

class FocusInterval: NSObject, Interval {
    
    var timer: Timer = Timer()
    weak var delegate: IntervalDelegate?
    var elapsedSeconds: TimeInterval = 0
    var targetSeconds: TimeInterval {
        return 60 * targetMinute
    }
    var targetMinute: TimeInterval {
        return 25
    }
    
    var themeColor: UIColor {
        return .red
    }
    
    var notiAction: UNNotificationAction {
        return UNNotificationAction(identifier: "interval.focus", title: "Start Break", options: [])
    }
    
    var notiContent: UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Time to Break!"
        content.body = "Well Done!!!"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = notiCategoryId
        return content
    }
    
    func startTimer() {
        setUpNotification(for: self)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            guard let strongSelf = self else { return }
            strongSelf.elapsedSeconds += 1
            strongSelf.delegate?.timeElapsed(strongSelf.elapsedSeconds)
        })
    }
    
    func stopTimer() {
        timer.invalidate()
        elapsedSeconds = 0
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func pauseTimer() {
        timer.invalidate()
        sendNotification()
    }
}

extension FocusInterval: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "asdf" {
            
        }
        completionHandler()
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}


