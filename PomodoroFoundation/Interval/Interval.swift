//
//  Interval.swift
//  Pomodoro
//
//  Created by 류성두 on 23/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

public protocol IntervalDelegate: class {
    func timeElapsed(_ seconds: TimeInterval)
    func intervalFinished(by finisher: IntervalFinisher)
}

public enum IntervalFinisher {
    case time
    case user
}

public protocol Interval {
    var timer: Timer { get set }
    var delegate: IntervalDelegate? { get set }
    var elapsedSeconds: TimeInterval { get set }
    var targetSeconds: TimeInterval { get }
    var targetMinute: TimeInterval { get }
    var themeColor: UIColor { get }
    var notiAction: UNNotificationAction{ get }
    var notiContent: UNMutableNotificationContent { get }
    var notiCategoryId: String { get }
    
    func startTimer()
    func stopTimer(by finisher:IntervalFinisher)
    func pauseTimer()
    func setUpNotification(for notiDelegate: UNUserNotificationCenterDelegate)
    func sendNotification()
}


extension Interval {
    
    public var notiCategoryId: String {
        return "asdfasdfasdf"
    }
    
    public func setUpNotification(for notiDelegate:UNUserNotificationCenterDelegate) {
        let center = UNUserNotificationCenter.current()
        center.delegate = notiDelegate
        center.requestAuthorization(options: [.alert, .sound],
                                    completionHandler: {(granted, error) in
                                        PermissionManager.shared.canSendLocalNotification = granted
        })
        let timerCategory = UNNotificationCategory(identifier: notiCategoryId,
                                                   actions: [notiAction], intentIdentifiers: [], options: [])
        center.setNotificationCategories([timerCategory])
    }
    
    public func sendNotification(){
        if PermissionManager.shared.canSendLocalNotification {
            let notiCenter = UNUserNotificationCenter.current()
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.001, repeats: false)
            let request = UNNotificationRequest(identifier: String(describing: self), content: notiContent, trigger: trigger)
            notiCenter.add(request) { (error) in
                if let error = error{
                    print("Error posting notification:\(error.localizedDescription)")
                }
            }
        }
    }
}