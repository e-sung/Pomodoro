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
            UIKeyCommand(title: "Toggle", action: #selector(startOrStopTimer), input: "\r"),
        ]
    }

    override func timeElapsed(_ seconds: TimeInterval) {
        super.timeElapsed(seconds)
        progressBar.setValue(interval.progress, animated: true)
    }

    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        startOrStopTimer()
        indicateCurrentStatus(on: sender.location(in: view))
    }

    @IBAction func buttonOpenInJiraTapped(_: Any) {
        guard let key = issue?.key else { return }
        guard let url = mainJiraDomain?.appendingPathComponent("browse/\(key)") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    @IBAction func closeButtonTapped(_: Any) {
        intervalFinished(by: .user, isFromBackground: false)
    }

    @IBAction func buttonIssueSelectorClicked(_: Any) {
        let issueVC = MyIssuesViewController.storyboardInstance
        issueVC.delegate = self
        present(issueVC, animated: true, completion: nil)
    }

    override func intervalFinished(by finisher: IntervalFinisher, isFromBackground: Bool) {
        super.intervalFinished(by: finisher, isFromBackground: isFromBackground)
        if let issue = issue, finisher == .time {
            let focusedTime = FocusInterval().targetMinute
            logWorkTime(seconds: focusedTime * 60, for: issue.key)
        }
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
                labelStatus.text = issue.key + "\n" + issue.sumamry
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

    /// 방금 클릭이 일시정지를 유발했는지, 또는 진행을 유발했는지를 애니메이션을 통해 알려줌
    private func indicateCurrentStatus(on point: CGPoint) {
        let originalSize = CGSize(width: 40, height: 40)
        let statusImageView = UIImageView(frame: CGRect(origin: point, size: originalSize))
        statusImageView.center = point
        statusImageView.image = interval.isActive ? UIImage(systemName: "play.fill") : UIImage(systemName: "pause.fill")
        statusImageView.tintColor = interval.themeColor.trackColor
        statusImageView.alpha = 0.8
        view.addSubview(statusImageView)
        UIView.animate(withDuration: 0.6, animations: {
            let grownSize = CGSize(width: 300, height: 300)
            statusImageView.frame = CGRect(origin: point, size: grownSize)
            statusImageView.center = point
            statusImageView.alpha = 0
        }, completion: { _ in
            statusImageView.removeFromSuperview()
        })
    }
}

extension MacTimerViewController: MyIssueViewControllerDelegate {
    func didSelect(issue: Issue?) {
        self.issue = issue
        refreshViews(with: interval)
    }
}
