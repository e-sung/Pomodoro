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

func registerBackgroundTimer() {
    let timerViewController = TimerViewController.shared
    guard let interval = timerViewController.interval, interval.isActive else { return }

    let remainingTime = interval.targetSeconds - interval.elapsedSeconds

    let timeToRing = Date(timeInterval: remainingTime, since: Date())
    let calendar = Calendar.autoupdatingCurrent
    let components = calendar.dateComponents(in: .current, from: timeToRing)
    let newComponents = DateComponents(calendar: calendar, timeZone: .current, hour: components.hour, minute: components.minute, second: components.second)
    let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)

    let request = UNNotificationRequest(identifier: "background.noti", content: interval.notiContent, trigger: trigger)
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.add(request, withCompletionHandler: nil)
}
