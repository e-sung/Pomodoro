//
//  FocusInterval.swift
//  Pomodoro
//
//  Created by 류성두 on 23/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

public class FocusInterval: NSObject, Interval {
    public var typeIdentifier: String {
        return className
    }

    public var timer: Timer = Timer()

    public weak var delegate: IntervalDelegate?

    public var notiAction: UNNotificationAction {
        return UNNotificationAction(identifier: "interval.break", title: "Start Break", options: [])
    }

    public var notiContent: UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Time to Break!"
        content.body = "Well Done!!!"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "focus.aiff"))
        content.categoryIdentifier = "TimeToBreak"
        return content
    }

    public var elapsedSeconds: TimeInterval = 0

    public var targetMinute: TimeInterval {
        let focusTimeAmount = retreiveAmount(for: .focusTime, from: UserDefaults(suiteName: "group.pomodoro.com")!)!
        return TimeInterval(exactly: focusTimeAmount)!
    }

    public var themeColor: ThemeColorSet {
        return ThemeColorSet(trackColor: UIColor(named: "FocusRed")!,
                             backgroundColor: UIColor(named: "FocusRed")!)
    }
}

public struct ThemeColorSet {
    public var trackColor: UIColor
    public var backgroundColor: UIColor
    public init(trackColor: UIColor, backgroundColor: UIColor) {
        self.trackColor = trackColor
        self.backgroundColor = backgroundColor
    }
}
