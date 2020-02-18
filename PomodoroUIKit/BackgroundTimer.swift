//
//  TimerViewController+Extension.swift
//  Pomodoro
//
//  Created by 류성두 on 26/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import Foundation
import PomodoroFoundation
import UIKit
import UserNotifications

public func registerBackgroundTimer(with interval: Interval) {
    guard interval.isActive else { return }

    let remainingTime = interval.targetSeconds - interval.elapsedSeconds

    let timeToRing = Date(timeInterval: remainingTime, since: Date())
    let calendar = Calendar.autoupdatingCurrent
    let target = calendar.dateComponents(in: .current, from: timeToRing)
    let dateComponent = DateComponents(day: target.day, hour: target.hour, minute: target.minute, second: target.second)
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)

    let request = UNNotificationRequest(identifier: "background.noti", content: interval.notiContent, trigger: trigger)
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.add(request, withCompletionHandler: nil)
}
