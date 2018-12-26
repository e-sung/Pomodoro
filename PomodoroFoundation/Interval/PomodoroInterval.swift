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
        setUpNotification(notiDelegate: notiDelegate)
    }

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
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        if finisher == .user {
            delegate?.intervalFinished(by: .user)
        }
        else {
            sendNotification()
        }
        
    }
    
    public func pauseTimer() {
        timer.invalidate()
    }
    
    var notiAction: UNNotificationAction {
        return UNNotificationAction(identifier: "interval.focus", title: "Start Break", options: [])
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
    
    func setUpNotification(notiDelegate:UNUserNotificationCenterDelegate) {
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
    
    func sendNotification(){
        if PermissionManager.shared.canSendLocalNotification {
            let notiCenter = UNUserNotificationCenter.current()
            let request = UNNotificationRequest(identifier: String(describing: self), content: notiContent, trigger: nil)
            notiCenter.add(request) { (error) in
                if let error = error{
                    print("Error posting notification:\(error.localizedDescription)")
                }
            }
        }
    }
}
