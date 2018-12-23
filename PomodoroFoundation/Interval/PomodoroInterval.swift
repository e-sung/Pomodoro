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

open class PomodoroInterval: NSObject, Interval {
    
    public var timer: Timer = Timer()
    public weak var delegate: IntervalDelegate?
    public var elapsedSeconds: TimeInterval = 0
    
    open var targetSeconds: TimeInterval {
        return 60 * targetMinute
    }
    open var targetMinute: TimeInterval {
        return 25
    }
    
    open var themeColor: UIColor {
        return UIColor(named: "Focus")!
    }
    
    open var notiAction: UNNotificationAction {
        return UNNotificationAction(identifier: "interval.focus", title: "Start Break", options: [])
    }
    
    open var notiContent: UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Time to Break!"
        content.body = "Well Done!!!"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = notiCategoryId
        return content
    }
    
    open func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            guard let strongSelf = self else { return }
            strongSelf.elapsedSeconds += 1
            strongSelf.delegate?.timeElapsed(strongSelf.elapsedSeconds)
            if strongSelf.elapsedSeconds > strongSelf.targetSeconds {
                strongSelf.stopTimer(by: .time)
            }
        })
    }
    
    open func stopTimer(by finisher: IntervalFinisher = .user) {
        timer.invalidate()
        elapsedSeconds = 0
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        if finisher == .user {
            delegate?.intervalFinished(by: .user)
        }
        else {
            sendNotification()
        }
        
    }
    
    open func pauseTimer() {
        timer.invalidate()
    }
}


