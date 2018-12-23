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
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        interval = FocusInterval()
        interval.delegate = self
        setUpInitialView()
    }
    
    func setUpInitialView(){
        mainSlider.endPointValue = 0
        mainSlider.maximumValue = CGFloat(interval.targetSeconds)
        mainSlider.isUserInteractionEnabled = false
        let currentFontSize = labelTime.font.pointSize
        labelTime.font = UIFont.monospacedDigitSystemFont(ofSize: currentFontSize, weight: .medium)
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
    
    func move(_ slider: CircularSlider, to time: TimeInterval) {
        let point = CGFloat(time)
        slider.endPointValue = point
        slider.layoutIfNeeded()
        valueChanged(slider)
    }
    
    func valueChanged(_ sender: CircularSlider) {
        guard let seconds = TimeInterval(exactly: sender.endPointValue) else { return }
        let date = Date(timeIntervalSince1970: seconds)
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("mm:ss")
        labelTime.text = dateFormatter.string(from: date)
    }
}
