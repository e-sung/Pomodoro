//
//  SimpleTimerViewController.swift
//  Pomodoro
//
//  Created by 류성두 on 21/04/2019.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import Foundation
// import GoogleMobileAds
import JiraSupport
import PomodoroFoundation
import PomodoroUIKit

class SimpleTimerViewController: TimerViewController {
    @IBOutlet private var progressBar: UIProgressView!
    @IBOutlet private var stackViewLabels: UIStackView!
    @IBOutlet private var labelStatus: UILabel!
    @IBOutlet private var navItem: UINavigationItem!
    var issue: Issue?
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if UIDevice.current.orientation.isPortrait {
            dismiss(animated: true, completion: nil)
        }
    }

//    var bannerView: GADBannerView!

    override func timeElapsed(_ seconds: TimeInterval) {
        super.timeElapsed(seconds)
        progressBar.progress = interval.progress
        let currentSecond = Int(interval.targetSeconds - seconds)
        if interval is BreakInterval, currentSecond == 60 {
//            UIView.animate(withDuration: 1, animations: { [weak self] in
//                self?.bannerView.alpha = 1
//            })
        }
    }

    override func intervalFinished(by finisher: IntervalFinisher, isFromBackground: Bool) {
        super.intervalFinished(by: finisher, isFromBackground: isFromBackground)
        if interval is FocusInterval {
//            UIView.animate(withDuration: 1, animations: { [weak self] in
//                self?.bannerView.alpha = 0
//            })
        }
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

    @IBAction func swipped(_ sender: UIPanGestureRecognizer) {
        let width = UIScreen.main.bounds.width
        print(sender.velocity(in: view))
        let velocity = abs(sender.velocity(in: view).x)
        guard velocity > 10 else { return }
        guard sender.numberOfTouches > 0 else { return }
        let swippingPoint = sender.location(ofTouch: 0, in: view)
        let xPos = swippingPoint.x
        let progress = TimeInterval(xPos / width)
        interval.elapsedSeconds = interval.targetSeconds * progress
        timeElapsed(interval.elapsedSeconds)
    }

    override func refreshViews(with interval: Interval) {
        updateLabelTime(with: interval.elapsedSeconds)
        progressBar.progressTintColor = interval.themeColor.backgroundColor
        progressBar.progress = interval.progress
        labelTime.isHidden = interval is FocusInterval
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
}
