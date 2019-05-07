//
//  TimerViewController.swift
//  Pomodoro
//
//  Created by 류성두 on 22/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import AudioToolbox
import CoreMotion
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
    @IBOutlet var rippleButton: UIButton!
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var imageViewControl: UIImageView!

    // MARK: Properties

    private let motionManager: CMMotionManager = CMMotionManager()
    private var shouldShowClearButton = false

    // MARK: LifeCycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.delegate = self
        clearButton.alpha = 0
        tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if hasOpenedByWidgetPlayPauseButton {
            interval.startOrPauseTimer()
            hasOpenedByWidgetPlayPauseButton = false
        }

        let shouldPreventSleep = retreiveBool(for: SettingContent.neverSleep, from: UserDefaults.shared)
        UIApplication.shared.isIdleTimerDisabled = shouldPreventSleep ?? true

        motionManager.startDeviceMotionUpdates(using: CMAttitudeReferenceFrame.xArbitraryCorrectedZVertical, to: OperationQueue.main) { [weak self] motion, error in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let motion = motion else { return }
            var accel = motion.userAcceleration.y.roundTo(places: 2)
            accel = abs(accel)
            guard self?.clearButton.layer.animationKeys() == nil else { return }
            if accel > 0.1 {
                self?.showClearButton()
            } else if self?.shouldShowClearButton == false {
                UIView.animate(withDuration: 0.5, animations: {
                    self?.clearButton.alpha = 0
                })
            }
        }
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        motionManager.stopDeviceMotionUpdates()
    }

    public override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            performSegue(withIdentifier: "showSimpleTimerVC", sender: nil)
        }
    }

    public override func startOrStopTimer() {
        super.startOrStopTimer()
        if interval.isActive == false {
            mainSlider.alpha = 0.7
            labelTime.alpha = 0.7
            imageViewControl.image = UIImage(named: "play")
        } else {
            mainSlider.alpha = 1
            labelTime.alpha = 1
            imageViewControl.image = UIImage(named: "pause")
        }
    }

    public override func refreshViews(with interval: Interval) {
        super.refreshViews(with: interval)
        refreshMainSlider(with: interval)
    }

    func showClearButton() {
        guard clearButton.layer.animationKeys() == nil else { return }
        shouldShowClearButton = true
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.clearButton.alpha = 1
        }, completion: { [weak self] _ in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10, execute: {
                self?.shouldShowClearButton = false
            })
        })
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

    @IBAction func backgroundTapped(_: Any) {
        showClearButton()
    }

    @IBAction func eggYellowClicked(_: Any) {
        startOrStopTimer()
        setAccessiblityHintOfRippleButton(given: interval)
    }

    @IBAction func clearButtonClicked(_: Any) {
        intervalFinished(by: .user, isFromBackground: false)
    }
}

// MARK: Update

extension MainTimerViewController {
    func refreshMainSlider(with interval: Interval) {
        mainSlider.maximumValue = CGFloat(interval.targetSeconds)
        mainSlider.trackFillColor = interval.themeColor.backgroundColor
        mainSlider.trackColor = interval.themeColor.trackColor
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
