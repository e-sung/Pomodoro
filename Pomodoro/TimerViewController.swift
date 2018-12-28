//
//  ViewController.swift
//  Pomodoro
//
//  Created by 류성두 on 22/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import HGCircularSlider
import PomodoroFoundation

public class TimerViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet var mainSlider: CircularSlider!
    @IBOutlet var labelTime: UILabel!
    @IBOutlet var labelIntervalCount: UILabel!
    @IBOutlet var playOrPauseButton: UIButton!
    
    // MARK: Properties
    var interval: Interval!
    var maxIntervalCount = 10
    var currentIntervalCount = 0

    // MARK: LifeCycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        setUpInitialValue()
        setUpInitialView()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpFonts()
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    // MARK: IBAction
    @IBAction func playOrPauseButtonClicked(_ sender: UIButton) {
        if sender.title(for: .normal) == "▶" {
            sender.setTitle("||", for: .normal)
            resetCycleIfDayHasPassed()
            interval.startTimer()
            
        }
        else {
            interval.pauseTimer()
            sender.setTitle("▶", for: .normal)
        }
    }
}

// MARK: SetUp
extension TimerViewController {
    func setUpInitialValue() {
        setUpNotification()
        interval = FocusInterval(intervalDelegate: self)
        resetCycleIfDayHasPassed()
        currentIntervalCount = retreiveCycle(from: UserDefaults.standard)
    }
    
    func resetCycleIfDayHasPassed() {
        let latestCycleDate = retreiveLatestCycleDate(from: UserDefaults.standard)
        if latestCycleDate.isYesterday {
            currentIntervalCount = 0
            saveCycles(currentIntervalCount, date: Date(), to: UserDefaults.standard)
        }
    }
    
    func setUpInitialView(){
        
        mainSlider.endPointValue = 0
        mainSlider.isUserInteractionEnabled = false
        updateMainSlider(with: interval)
        
        setUpFonts()
        updateLabelTime(with: 0)

        playOrPauseButton.setTitle("▶", for: .normal)
        
        labelIntervalCount.text = "\(currentIntervalCount) / \(maxIntervalCount)"
    }
    
    func setUpFonts() {
        let currentFontSize = labelTime.font.pointSize
        labelTime.font = UIFont.monospacedDigitSystemFont(ofSize: currentFontSize, weight: .light)
    }
}

// MARK: Update
extension TimerViewController {
    func updateMainSlider(with interval:Interval) {
        mainSlider.maximumValue = CGFloat(interval.targetSeconds)
        mainSlider.trackColor = interval.themeColor
        mainSlider.trackFillColor = interval.themeColor
        mainSlider.setNeedsDisplay()
    }
    
    func updateMainSlider(to time: TimeInterval) {
        let point = CGFloat(time)
        mainSlider.endPointValue = point
        mainSlider.layoutIfNeeded()
    }
    
    func updateLabelTime(with seconds:TimeInterval) {
        guard seconds <= interval.targetSeconds else { return }
        let date = Date(timeIntervalSince1970: interval.targetSeconds - seconds)
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("mm:ss")
        labelTime.text = dateFormatter.string(from: date)
    }
}

// MARK: IntervalDelegate
extension TimerViewController: IntervalDelegate {
    public func intervalFinished(by finisher: IntervalFinisher) {
        clearPendingNotifications(on: UNUserNotificationCenter.current())
        add(notiAction: interval.notiAction, for: interval.notiContent, to: UNUserNotificationCenter.current())
        publishNotiContent(of: interval, via: UNUserNotificationCenter.current())
        
        if finisher == .time && interval is BreakInterval {
            currentIntervalCount += 1
            saveCycles(currentIntervalCount, to: UserDefaults.standard)
        }
        
        if interval is FocusInterval {
            interval = BreakInterval(intervalDelegate: self)
        }
        else {
            interval = FocusInterval(intervalDelegate: self)
        }

        setUpInitialView()
    }
    
    public func timeElapsed(_ seconds: TimeInterval) {
        updateLabelTime(with: seconds)
        updateMainSlider(to: seconds)
    }
}

// MARK: Notification
extension TimerViewController {
    
    func clearPendingNotifications(on notiCenter: UNUserNotificationCenter) {
        notiCenter.removeAllPendingNotificationRequests()
        notiCenter.removeAllDeliveredNotifications()
    }
    
    func add(notiAction: UNNotificationAction, for notiContent: UNNotificationContent, to notiCenter: UNUserNotificationCenter) {
        let timerCategory = UNNotificationCategory(identifier: notiContent.categoryIdentifier,
                                                   actions: [notiAction], intentIdentifiers: [], options: [])
        notiCenter.setNotificationCategories([timerCategory])
    }
    
    func setUpNotification() {
        let notiCenter = UNUserNotificationCenter.current()
        notiCenter.delegate = self
        notiCenter.requestAuthorization(options: [.alert, .sound],
                                        completionHandler: {(granted, error) in
                                            PermissionManager.shared.canSendLocalNotification = granted
        })
    }
    
    func publishNotiContent(of interval: Interval, via notiCenter: UNUserNotificationCenter) {
        if PermissionManager.shared.canSendLocalNotification {
            // TODO: meaningful identifier
            let request = UNNotificationRequest(identifier: Date().debugDescription,
                                                content: interval.notiContent,
                                                trigger: nil)
            notiCenter.add(request) { (error) in
                if let error = error{
                    print("Error posting notification:\(error.localizedDescription)")
                }
            }
        }
    }
}


// MARK: UserNotificationExtension
extension TimerViewController: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "background.noti" {
            intervalFinished(by: .time)
            if response.actionIdentifier != "com.apple.UNNotificationDefaultActionIdentifier" {
                registerBackgroundTimer()
            }
        }
        else {
            playOrPauseButtonClicked(playOrPauseButton)
        }
        completionHandler()
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
}

// MARK: Etc
fileprivate extension Date {
    var isYesterday: Bool {
        return day != Date().day
    }
    var day: String {
        let formatter = DateFormatter.standard
        formatter.dateFormat = "dd"
        return formatter.string(from: self)
    }
}
