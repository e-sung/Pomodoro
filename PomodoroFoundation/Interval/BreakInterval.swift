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

public class BreakInterval: NSObject, Interval {
    public var timer: Timer = Timer()
    
    public weak var delegate: IntervalDelegate?
    
    public init(intervalDelegate: IntervalDelegate) {
        super.init()
        self.delegate = intervalDelegate
    }
    
    public var elapsedSeconds: TimeInterval = 0

    public var targetSeconds: TimeInterval {
        return 3
//        return 60 * targetMinute
    }
    public var targetMinute: TimeInterval {
        return 5
    }
    
    public var themeColor: UIColor {
        return UIColor(named: "Break")!
    }
    
    public var notiAction: UNNotificationAction {
        return UNNotificationAction(identifier: "interval.focus", title: "Start Focus", options: [])
    }
    
    public var notiContent: UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Time to Focus!"
        content.body = "Cheer Up!!!"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "TimeToFocus"
        return content
    }
}



