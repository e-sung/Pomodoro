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

    override func refreshViews(with interval: Interval) {
        updateLabelTime(with: interval.elapsedSeconds)
        progressBar.progressTintColor = interval.themeColor.trackColor
        progressBar.progress = interval.progress
        stackViewLabels.isHidden = interval is FocusInterval
    }
}
