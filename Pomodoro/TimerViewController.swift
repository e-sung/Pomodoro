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



public class TimerViewController: UIViewController {
    
    @IBOutlet var mainSlider: CircularSlider!
    @IBOutlet var labelTime: UILabel!
    
    var interval: Interval!
    
    var timer = Timer()
    var targetMinute: TimeInterval = 25
    var targetSeconds:TimeInterval {
        return targetMinute * 60
    }
    var elapsedSeconds:TimeInterval = 0
    var canSendLocalNotification = false
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        interval = FocusInterval()
        interval.delegate = self
        setUpInitialView()
    }
    
    func setUpInitialView(){
        mainSlider.endPointValue = 0
        mainSlider.maximumValue = CGFloat(targetSeconds)
        mainSlider.isUserInteractionEnabled = false
        let currentFontSize = labelTime.font.pointSize
        labelTime.font = UIFont.monospacedDigitSystemFont(ofSize: currentFontSize, weight: .medium)
    }
    
    func move(_ slider: CircularSlider, to time: TimeInterval) {
        let point = CGFloat(time)
        slider.endPointValue = point
        slider.layoutIfNeeded()
        valueChanged(slider)
    }
    
    @IBAction func valueChanged(_ sender: CircularSlider) {
        guard let seconds = TimeInterval(exactly: sender.endPointValue) else { return }
        let date = Date(timeIntervalSince1970: seconds)
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("mm:ss")
        labelTime.text = dateFormatter.string(from: date)
    }
    
    @IBAction func playOrPauseButtonClicked(_ sender: UIButton) {
        if sender.title(for: .normal) == "▶" {
            sender.setTitle("||", for: .normal)
            interval.startTimer()
        }
        else {
            interval.pauseTimer()
            sender.setTitle("▶", for: .normal)
        }
    }
}
extension TimerViewController: IntervalDelegate {
    func timeElapsed(_ seconds: TimeInterval) {
        move(mainSlider, to: seconds)
    }
}


extension TimerViewController: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    

//

}
