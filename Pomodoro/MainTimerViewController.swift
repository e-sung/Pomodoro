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
import GoogleMobileAds
import HGCircularSlider
import PomodoroFoundation
import PomodoroSettings
import PomodoroUIKit
import RxCocoa
import RxSwift
import UIKit
import UserNotifications

public class MainTimerViewController: TimerViewController {
    // MARK: IBOutlets

    @IBOutlet var mainSlider: CircularSlider!
    @IBOutlet var rippleButton: UIButton!
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var imageViewControl: UIImageView!
    var bannerView: GADBannerView!

    // MARK: Properties

    private let motionManager: CMMotionManager = CMMotionManager()
    private var shouldShowClearButton: Bool {
        if let lastClearButtonShownTime = lastClearButtonShownTime {
            let timePassed = Date().timeIntervalSince(lastClearButtonShownTime)
            return timePassed > 10
        }
        return true
    }

    public override var prefersStatusBarHidden: Bool {
        return true
    }

    var acceleration = BehaviorRelay<Double>(value: 0)
    var lastClearButtonShownTime: Date?
    var disposeBag = DisposeBag()

    // MARK: LifeCycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.delegate = self
        tabBarItem.accessibilityLabel = NSLocalizedString("main_timer", comment: "")
        clearButton.alpha = 0
        tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        bannerView = makeBannerView()
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        bannerView.alpha = 0
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.barStyle = .blackOpaque
        tabBarController?.tabBar.tintColor = .white
        if view.subviews.contains(bannerView) == false {
            addBannerViewToView(bannerView)
        }
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if UIDevice.current.orientation.isLandscape {
            performSegue(withIdentifier: "showSimpleTimerVC", sender: nil)
        }
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if hasOpenedByWidgetPlayPauseButton {
            interval.startOrPauseTimer()
            hasOpenedByWidgetPlayPauseButton = false
        }

        let shouldPreventSleep = retreiveBool(for: SettingContent.neverSleep, from: UserDefaults.shared)
        UIApplication.shared.isIdleTimerDisabled = shouldPreventSleep ?? true
        bindAccel(acceleration, to: motionManager)
        showOrHide(clearButton, by: acceleration)
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

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let nextVC = segue.destination as? SimpleTimerViewController else { return }
        bannerView.removeFromSuperview()
        nextVC.bannerView = bannerView
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
        if interval.isActive {
            imageViewControl.image = UIImage(named: "pause")
        } else {
            imageViewControl.image = UIImage(named: "play")
        }
    }

    public override func intervalFinished(by finisher: IntervalFinisher, isFromBackground: Bool) {
        super.intervalFinished(by: finisher, isFromBackground: isFromBackground)
        if interval is FocusInterval {
            UIView.animate(withDuration: 1, animations: { [weak self] in
                self?.bannerView.alpha = 0
            })
        }
    }

    public override func timeElapsed(_ seconds: TimeInterval) {
        super.timeElapsed(seconds)
        updateMainSlider(to: seconds)
        let currentSecond = Int(interval.targetSeconds - seconds)
        if interval is BreakInterval, currentSecond == 60 {
            UIView.animate(withDuration: 1, animations: { [weak self] in
                self?.bannerView.alpha = 1
            })
        }
    }

    public override func applyNewSetting() {
        super.applyNewSetting()
        let shouldPreventSleep = retreiveBool(for: SettingContent.neverSleep, from: UserDefaults.shared)
        UIApplication.shared.isIdleTimerDisabled = shouldPreventSleep ?? true
    }

    // MARK: IBAction

    @IBAction func backgroundTapped(_: Any) {
        acceleration.accept(1)
    }

    @IBAction func mainCircleClicked(_: Any) {
        startOrStopTimer()
        setAccessiblityHintOfRippleButton(given: interval)
    }

    @IBAction func clearButtonClicked(_: Any) {
        intervalFinished(by: .user, isFromBackground: false)
    }

    @IBAction func sliderDidSlide(_ slider: CircularSlider) {
        interval.elapsedSeconds = interval.targetSeconds * slider.progress
        timeElapsed(interval.elapsedSeconds)
    }

    private func bindAccel(_ acceleration: BehaviorRelay<Double>, to motionManager: CMMotionManager) {
        motionManager.startDeviceMotionUpdates(using: CMAttitudeReferenceFrame.xArbitraryCorrectedZVertical, to: OperationQueue.main) { motion, error in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let motion = motion else { return }
            var accel = motion.userAcceleration.y
            accel = abs(accel)
            acceleration.accept(accel)
        }
    }

    private func showOrHide(_ clearButton: UIButton, by accel: BehaviorRelay<Double>) {
        accel
            .filter({ $0 > 0.1 })
            .filter({ [weak self] _ in self?.shouldShowClearButton == true })
            .filter({ _ in clearButton.layer.animationKeys() == nil })
            .filter({ _ in clearButton.alpha == 0 })
            .do(onNext: { _ in
                UIView.animate(withDuration: 0.5, animations: {
                    clearButton.alpha = 1
                })
            })
            .delay(RxTimeInterval(floatLiteral: 10), scheduler: MainScheduler.instance)
            .bind(onNext: { _ in
                UIView.animate(withDuration: 0.5, animations: {
                    clearButton.alpha = 0
                })
            })
            .disposed(by: disposeBag)
    }
}

extension CircularSlider {
    var progress: TimeInterval {
        return TimeInterval(endPointValue / maximumValue)
    }
}

// MARK: Update

extension MainTimerViewController {
    func refreshMainSlider(with interval: Interval) {
        mainSlider.maximumValue = CGFloat(interval.targetSeconds)
        mainSlider.trackFillColor = interval.themeColor.backgroundColor
        mainSlider.trackColor = interval.themeColor.trackColor.withAlphaComponent(0.7)
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

extension MainTimerViewController: GADBannerViewDelegate {
    public func adViewDidReceiveAd(_: GADBannerView) {}
}
