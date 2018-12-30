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

public class FocusInterval: NSObject, Interval {
    
    public var timer: Timer = Timer()
    
    public weak var delegate: IntervalDelegate?
    
    public init(intervalDelegate: IntervalDelegate? = nil) {
        super.init()
        self.delegate = intervalDelegate
    }

    public var notiAction: UNNotificationAction {
        return UNNotificationAction(identifier: "interval.break", title: "Start Break", options: [])
    }
    
    public var notiContent: UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Time to Break!"
        content.body = "Well Done!!!"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "TimeToBreak"
        return content
    }

    public var elapsedSeconds: TimeInterval = 0
    
    public var targetSeconds: TimeInterval {
//        return 5
                return 60 * targetMinute
    }
    public var targetMinute: TimeInterval {
        
        return 25
    }
    
    public var themeColor: UIColor {
        return UIColor(named: "Focus")!
    }
}

