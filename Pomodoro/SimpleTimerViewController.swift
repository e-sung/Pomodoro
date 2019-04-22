//
//  SimpleTimerViewController.swift
//  Pomodoro
//
//  Created by 류성두 on 21/04/2019.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import Foundation
import PomodoroFoundation
import PomodoroUIKit

class SimpleTimerViewController: TimerViewController {
    @IBOutlet private var progressBar: UIProgressView!
    @IBOutlet private var stackViewLabels: UIStackView!
    @IBOutlet private var labelStatus: UILabel!
    @IBOutlet private var navItem: UINavigationItem!
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if UIDevice.current.orientation.isPortrait {
            dismiss(animated: true, completion: nil)
        }
    }

    override func timeElapsed(_ seconds: TimeInterval) {
        super.timeElapsed(seconds)
        progressBar.progress = interval.progress
    }

    @IBAction func backgroundTapped(_: Any) {
        startOrStopTimer()
    }

    @IBAction func closeButtonTapped(_: Any) {
        intervalFinished(by: .user, isFromBackground: false)
    }

    override func startOrStopTimer() {
        super.startOrStopTimer()
        updateControlButton()
        if interval.isActive {
            progressBar.alpha = 1
        } else {
            progressBar.alpha = 0.5
        }
    }

    func updateControlButton() {
        var button: UIBarButtonItem!
        if interval.isActive {
            button = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(startOrStopTimer))
        } else {
            button = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(startOrStopTimer))
        }
        button.tintColor = UIColor.gray
        navItem.leftBarButtonItem = button
    }

    override func refreshViews(with interval: Interval) {
        updateLabelTime(with: interval.elapsedSeconds)
        progressBar.progressTintColor = interval.themeColor.backgroundColor
        progressBar.progress = interval.progress
        labelTime.isHidden = interval is FocusInterval
        updateControlButton()
        if interval is FocusInterval {
            labelStatus.text = "집중중"
        } else {
            labelStatus.text = "휴식중"
        }
    }
}
