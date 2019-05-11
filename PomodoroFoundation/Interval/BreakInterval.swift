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

public class BreakInterval: NSObject, Interval {
    public var typeIdentifier: String {
        return className
    }

    public var timer: Timer = Timer()

    public weak var delegate: IntervalDelegate?

    public var elapsedSeconds: TimeInterval = 0

    public var targetMinute: TimeInterval {
        let breakTimeAmount = retreiveAmount(for: .breakTime, from: UserDefaults(suiteName: "group.pomodoro.com")!)!
        return TimeInterval(exactly: breakTimeAmount)!
    }

    public var themeColor: ThemeColorSet {
        return ThemeColorSet(trackColor: UIColor(named: "BreakGreen")!,
                             backgroundColor: UIColor(named: "BreakGreen")!)
    }

    public var notiAction: UNNotificationAction {
        return UNNotificationAction(identifier: "interval.focus", title: NSLocalizedString("start_focusing", comment: ""),
                                    options: [])
    }

    public var notiContent: UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("noti_time_to_focus_title", comment: "")
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "chime_wash.wav"))
        content.categoryIdentifier = "TimeToFocus"
        return content
    }
}
