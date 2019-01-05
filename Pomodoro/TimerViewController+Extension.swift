//
//  TimerViewController+Extension.swift
//  Pomodoro
//
//  Created by 류성두 on 26/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import PomodoroFoundation


func registerBackgroundTimer() {
    let timerViewController = TimerViewController.shared
    guard let interval = timerViewController.interval, interval.isActive else { return }
    
    saveDateBackgroundEntered(Date(), to: UserDefaults.standard)
    saveInterval(interval, to: UserDefaults.standard)
    
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
