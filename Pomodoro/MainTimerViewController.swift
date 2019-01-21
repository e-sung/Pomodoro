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
    @IBOutlet var dashboardLabels: [UILabel]!
    @IBOutlet var labelTimeFocusedTodayTitle: UILabel!
    @IBOutlet var labelTimeFocusedTodayContent: UILabel!
    @IBOutlet var labelDashboardTitle: UILabel!

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

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if hasOpenedByWidgetPlayPauseButton {
            interval.startOrPauseTimer()
            hasOpenedByWidgetPlayPauseButton = false
        }

        let shouldPreventSleep = retreiveBool(for: SettingContent.neverSleep, from: UserDefaults.shared)
        UIApplication.shared.isIdleTimerDisabled = shouldPreventSleep ?? true
    }

    public override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)

        coordinator.animate(alongsideTransition: { [weak self] _ in
            guard let strongSelf = self else { return }
            var alphaOfEggWhite: CGFloat = 0
            self?.showOrHideDashboardLabels(given: newCollection.verticalSizeClass)
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
        refreshMainSlider(with: interval)
        
        showOrHideDashboardLabels(given: traitCollection.verticalSizeClass)
        labelIntervalCount.text = "\(currentCycleCount) / \(maxCycleCount)"
        setAccessibilityHintOfLabelIntervalCount()
    }
    
    func showOrHideDashboardLabels(given verticalSizeClass: UIUserInterfaceSizeClass) {
        if verticalSizeClass == .compact {
            dashboardLabels.forEach({ $0.isHidden = (interval is FocusInterval) })
        } else {
            dashboardLabels.forEach({ $0.isHidden = true })
        }
    }

    public override func timeElapsed(_ seconds: TimeInterval) {
        super.timeElapsed(seconds)
        updateMainSlider(to: seconds)
    }

    public override func applyNewSetting() {
        super.applyNewSetting()
        let shouldPreventSleep = retreiveBool(for: SettingContent.neverSleep, from: UserDefaults.shared)
        UIApplication.shared.isIdleTimerDisabled = shouldPreventSleep ?? true
    }

    // MARK: IBAction

    @IBAction func eggYellowClicked(_: Any) {
        startOrStopTimer()
        setAccessiblityHintOfRippleButton(given: interval)
    }
}

// MARK: Update

extension MainTimerViewController {
    func refreshMainSlider(with interval: Interval) {
        mainSlider.maximumValue = CGFloat(interval.targetSeconds)
        if traitCollection.verticalSizeClass == .compact {
            mainSlider.trackFillColor = .clear
        } else {
            mainSlider.trackFillColor = interval.themeColor.trackColor
        }
        updateMainSlider(to: interval.elapsedSeconds)
        setAccessiblityHintOfRippleButton(given: interval)
        mainSlider.setNeedsDisplay()
    }

    func updateMainSlider(to time: TimeInterval) {
        let point = CGFloat(time)
        mainSlider.endPointValue = point
        mainSlider.layoutIfNeeded()
    }

    func setAccessiblityHintOfRippleButton(given interval: Interval) {
        if interval.isActive {
            rippleButton.accessibilityHint = NSLocalizedString("timerRunning", comment: "")
        } else {
            rippleButton.accessibilityHint = NSLocalizedString("timerPaused", comment: "")
        }
    }

    func setAccessibilityHintOfLabelIntervalCount() {
        let goalFormatString = NSLocalizedString("cycle goal accessibility hint", comment: "")
        let goalString = String.localizedStringWithFormat(goalFormatString, maxCycleCount)

        let completedCycleFormatString = NSLocalizedString("completed cycle accessibility hint", comment: "")
        let completedCycleString = String.localizedStringWithFormat(completedCycleFormatString, currentCycleCount)
        labelIntervalCount.accessibilityLabel = goalString + ". " + completedCycleString
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
