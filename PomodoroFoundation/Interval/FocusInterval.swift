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

public class FocusInterval: PomodoroInterval {

    override public var targetSeconds: TimeInterval {
        return 7
//        return 60 * targetMinute
    }
    override public var targetMinute: TimeInterval {
        return 25
    }
    
    override public var themeColor: UIColor {
        return .red
    }
    
    override public var notiAction: UNNotificationAction {
        return UNNotificationAction(identifier: "interval.focus", title: "Start Break", options: [])
    }
    
    override public var notiContent: UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Time to Break!"
        content.body = "Well Done!!!"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = notiCategoryId
        return content
    }

}
