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

public class PomodoroInterval: NSObject, Interval {
    
    var timer: Timer = Timer()
    public weak var delegate: IntervalDelegate?
    public var elapsedSeconds: TimeInterval = 0
    public var isActive: Bool {
        return timer.isValid
    }
    
    public init(intervalDelegate: IntervalDelegate, notiDelegate: UNUserNotificationCenterDelegate) {
        super.init()
        self.delegate = intervalDelegate
//        setUpNotiAction(notiDelegate: notiDelegate)
    }

    public var targetSeconds: TimeInterval {
        return 5
//        return 60 * targetMinute
    }
    public var targetMinute: TimeInterval {
        return 25
    }
    
    public var themeColor: UIColor {
        return UIColor(named: "Focus")!
    }
    
    public func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            guard let strongSelf = self else { return }
            strongSelf.elapsedSeconds += 1
            strongSelf.delegate?.timeElapsed(strongSelf.elapsedSeconds)
            if strongSelf.elapsedSeconds > strongSelf.targetSeconds {
                strongSelf.stopTimer(by: .time)
            }
        })
    }
    
    public func stopTimer(by finisher: IntervalFinisher = .user) {
        timer.invalidate()
        elapsedSeconds = 0
        delegate?.intervalFinished(by: finisher)
    }
    
    public func pauseTimer() {
        timer.invalidate()
    }
    
    public var notiAction: UNNotificationAction {
        return UNNotificationAction(identifier: "interval.break", title: "Start Break", options: [])
    }
    
    public var notiContent: UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Time to Break!"
        content.body = "Well Done!!!"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = notiCategoryId
        return content
    }
    
    var notiCategoryId: String {
        return "asdfasdfasdf"
    }
}
