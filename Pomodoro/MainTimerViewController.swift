//
//  TimerViewController.swift
//  Pomodoro
//
//  Created by 류성두 on 22/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import AudioToolbox
import Foundation
import HGCircularSlider
import PomodoroFoundation
import PomodoroSettings
import PomodoroUIKit
import UIKit
import UserNotifications

public class MainTimerViewController: TimerViewController {
    // MARK: IBOutlets

    @IBOutlet var mainSlider: CircularSlider!
    @IBOutlet var labelIntervalCount: UILabel!
    @IBOutlet var rippleButton: RippleButton!
    @IBOutlet var imageViewEggWhite: UIImageView!

    // MARK: Properties

    public static var shared: MainTimerViewController {
        let application = UIApplication.shared
        let tabBarController = application.keyWindow?.rootViewController as? UITabBarController
        guard let timerViewController = tabBarController?
            .viewControllers?
            .compactMap({ $0 as? MainTimerViewController })
            .first else {
            fatalError("Couldn't Load TimerViewController.")
        }
        return timerViewController
    }

    // MARK: LifeCycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.delegate = self
        rippleButton.buttonCornerRadius = Float(mainSlider.frame.width / 2)
    }

    public override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)

        coordinator.animate(alongsideTransition: { [weak self] _ in
            guard let strongSelf = self else { return }
            var alphaOfEggWhite: CGFloat = 0
            if newCollection.verticalSizeClass == .compact {
                self?.mainSlider.trackFillColor = .clear
            } else {
                alphaOfEggWhite = 1
                self?.mainSlider.trackFillColor = strongSelf.interval.themeColor.trackColor
            }

            self?.imageViewEggWhite.alpha = alphaOfEggWhite
            self?.mainSlider.setNeedsDisplay()
        })
    }

    public override func refreshViews(with interval: Interval) {
        super.refreshViews(with: interval)
        updateMainSlider(with: interval)
        labelIntervalCount.text = "\(currentCycleCount) / \(maxCycleCount)"
    }

    public override func timeElapsed(_ seconds: TimeInterval) {
        super.timeElapsed(seconds)
        updateMainSlider(to: seconds)
    }

    // MARK: IBAction

    @IBAction func eggYellowClicked(_: Any) {
        startOrStopTimer()
    }
}

// MARK: Update

extension MainTimerViewController {
    func updateMainSlider(with interval: Interval) {
        mainSlider.maximumValue = CGFloat(interval.targetSeconds)
        if traitCollection.verticalSizeClass == .compact {
            mainSlider.trackFillColor = .clear
        } else {
            mainSlider.trackFillColor = interval.themeColor.trackColor
        }
        updateMainSlider(to: interval.elapsedSeconds)
        mainSlider.setNeedsDisplay()
    }

    func updateMainSlider(to time: TimeInterval) {
        let point = CGFloat(time)
        mainSlider.endPointValue = point
        mainSlider.layoutIfNeeded()
    }
}

extension MainTimerViewController: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect _: UIViewController) -> Bool {
        let selectedNavigationController = tabBarController.selectedViewController as? UINavigationController
        if selectedNavigationController?.topViewController is SettingsTableViewController {
            applyNewSetting()
        }
        return true
    }
}
