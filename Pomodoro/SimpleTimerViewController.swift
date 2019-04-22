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
        progressBar.progressTintColor = interval.themeColor.trackColor
        progressBar.progress = interval.progress
        stackViewLabels.isHidden = interval is FocusInterval
        updateControlButton()
    }
}
