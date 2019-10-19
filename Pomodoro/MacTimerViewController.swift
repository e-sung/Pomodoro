//
//  MacTimerViewController.swift
//  Pomodoro
//
//  Created by 류성두 on 2019/10/19.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import JiraSupport
import PomodoroFoundation
import PomodoroUIKit
import UIKit

class MacTimerViewController: TimerViewController {
    @IBOutlet private var progressBar: UISlider!
    @IBOutlet private var stackViewLabels: UIStackView!
    @IBOutlet private var labelStatus: UILabel!
    @IBOutlet private var navItem: UINavigationItem!
    @IBOutlet private var buttonIssue: UIButton!

    var issue: Issue?

    override var keyCommands: [UIKeyCommand]? {
        return [
            UIKeyCommand(title: "Toggle", action: #selector(startOrStopTimer), input: " "),
            UIKeyCommand(title: "Toggle", action: #selector(startOrStopTimer), input: "\r")
        ]
    }

    override func timeElapsed(_ seconds: TimeInterval) {
        super.timeElapsed(seconds)
        progressBar.setValue(interval.progress, animated: true)
    }

    @IBAction func backgroundTapped(_: Any) {
        startOrStopTimer()
    }

    @IBAction func closeButtonTapped(_: Any) {
        intervalFinished(by: .user, isFromBackground: false)
    }

    @IBAction func buttonIssueSelectorClicked(_: Any) {
        let issueVC = MyIssuesViewController.storyboardInstance
        issueVC.delegate = self
        present(issueVC, animated: true, completion: nil)
    }

    @objc override func startOrStopTimer() {
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
        progressBar.tintColor = interval.themeColor.backgroundColor
        progressBar.setValue(interval.progress, animated: true)
        updateControlButton()
        if interval is FocusInterval {
            if let issue = issue {
                labelStatus.text = issue.sumamry
            } else {
                labelStatus.text = NSLocalizedString("focusing", comment: "")
            }
        } else {
            labelStatus.text = NSLocalizedString("resting", comment: "")
        }
    }

    @IBAction func sliderSlided(_: Any?) {
        interval.elapsedSeconds = interval.targetSeconds * TimeInterval(progressBar.value)
        timeElapsed(interval.elapsedSeconds)
    }
}

extension MacTimerViewController: MyIssueViewControllerDelegate {
    func didSelect(issue: Issue?) {
        self.issue = issue
        refreshViews(with: interval)
    }
}
