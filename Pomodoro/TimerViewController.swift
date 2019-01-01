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
    @IBOutlet var labelTime: UILabel! {
        didSet {
            print(labelTime)
        }
    }
    @IBOutlet var labelIntervalCount: UILabel!
    @IBOutlet var playOrPauseButton: UIButton!
    @IBOutlet var rightEdgeGR: UIScreenEdgePanGestureRecognizer!
    
    // MARK: Properties
    var interval: Interval!
    var maxCycleCount: Int {
        return retreiveAmount(for: .target, from: UserDefaults.standard)!
    }
    var currentCycleCount = 0
    var cycleCountForLongBreak = 3
    var notificationManager:NotificationManager!

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
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.setUpFonts()
            }, completion: nil)
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
    
    @IBAction func unwindToTimerViewController(_ unwindSegue: UIStoryboardSegue) {
        if interval is FocusInterval {
            interval = FocusInterval(intervalDelegate: self)
        }
        else if interval is BreakInterval {
            interval = BreakInterval(intervalDelegate: self)
        }
        else if interval is LongBreakInterval {
            interval = LongBreakInterval(intervalDelegate: self)
        }
        setUpInitialView()
    }
    
    @IBAction func rightPanelSwiped(_ sender: UIScreenEdgePanGestureRecognizer) {
    }
}

// MARK: SetUp
extension TimerViewController {
    func setUpInitialValue() {
        notificationManager = NotificationManager(delegate: self)
        interval = FocusInterval(intervalDelegate: self)
        resetCycleIfDayHasPassed()
        currentCycleCount = retreiveCycle(from: UserDefaults.standard)
    }
    
    func resetCycleIfDayHasPassed() {
        let latestCycleDate = retreiveLatestCycleDate(from: UserDefaults.standard)
        if latestCycleDate.isYesterday {
            currentCycleCount = 0
            saveCycles(currentCycleCount, date: Date(), to: UserDefaults.standard)
        }
    }
    
    func setUpInitialView(){
        
        mainSlider.endPointValue = 0
        mainSlider.isUserInteractionEnabled = false
        updateMainSlider(with: interval)
        
        setUpFonts()
        updateLabelTime(with: 0)

        playOrPauseButton.setTitle("▶", for: .normal)
        
        labelIntervalCount.text = "\(currentCycleCount) / \(maxCycleCount)"
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
        notificationManager.publishNotiContent(of: interval, via: UNUserNotificationCenter.current())
        
        if finisher == .time && interval is BreakInterval {
            currentCycleCount += 1
            saveCycles(currentCycleCount, to: UserDefaults.standard)
        }
        
        resetInterval()
        setUpInitialView()
    }
    
    func resetInterval() {
        if interval is FocusInterval {
            if (currentCycleCount + 1) % cycleCountForLongBreak == 0 {
                interval = LongBreakInterval(intervalDelegate: self)
            }
            else {
                interval = BreakInterval(intervalDelegate: self)
            }
        }
        else if interval is BreakInterval {
            interval = FocusInterval(intervalDelegate: self)
        }
    }
    
    public func timeElapsed(_ seconds: TimeInterval) {
        updateLabelTime(with: seconds)
        updateMainSlider(to: seconds)
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
