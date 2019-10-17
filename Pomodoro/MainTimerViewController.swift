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
import JiraSupport
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
    @IBOutlet var buttonIssue: UIButton!
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

    var acceleration = BehaviorRelay<Double>(value: 0)
    var lastClearButtonShownTime: Date?
    var selectedIssue: Issue?
    var disposeBag = DisposeBag()

    // MARK: LifeCycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.delegate = self
        tabBarItem.accessibilityLabel = NSLocalizedString("main_timer", comment: "")
        clearButton.alpha = 0

        setUpBannerView()
        bindAccel(acceleration, to: motionManager)
        showOrHide(clearButton, by: acceleration)
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.barStyle = .black
        tabBarController?.tabBar.isTranslucent = true
        tabBarController?.tabBar.tintColor = .white
        tabBarController?.tabBar.unselectedItemTintColor = .gray
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
        nextVC.issue = selectedIssue
    }

    public override func startOrStopTimer() {
        super.startOrStopTimer()
        if interval.isActive == false {
            mainSlider.alpha = 0.7
            labelTime.alpha = 0.7
            imageViewControl.image = UIImage(systemName: "play.fill")
        } else {
            mainSlider.alpha = 1
            labelTime.alpha = 1
            imageViewControl.image = UIImage(systemName: "pause.fill")
        }
    }

    public override func refreshViews(with interval: Interval) {
        super.refreshViews(with: interval)
        refreshMainSlider(with: interval)
        if interval.isActive {
            imageViewControl.image = UIImage(systemName: "pause.fill")
        } else {
            imageViewControl.image = UIImage(systemName: "play.fill")
        }
    }

    public override func intervalFinished(by finisher: IntervalFinisher, isFromBackground: Bool) {
        super.intervalFinished(by: finisher, isFromBackground: isFromBackground)
        if UIApplication.shared.applicationState != .active {
            interval.pauseTimer()
            imageViewControl.image = UIImage(systemName: "play.fill")
        }
        if interval is FocusInterval {
            UIView.animate(withDuration: 1, animations: { [weak self] in
                self?.bannerView.alpha = 0
            })
        } else if let issue = selectedIssue, finisher == .time {
            let focusedTime = FocusInterval().targetMinute
            logWorkTime(seconds: focusedTime * 60, for: issue.key)
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

    @objc func rotated() {
        if UIDevice.current.orientation.isLandscape, presentedViewController == nil {
            performSegue(withIdentifier: "showSimpleTimerVC", sender: nil)
        }
    }

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

    @IBAction func buttonIssueClicked(_: Any) {
        let issueVC = MyIssuesViewController.storyboardInstance
        issueVC.delegate = self
        present(issueVC, animated: true, completion: nil)
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
            .delay(RxTimeInterval.seconds(10), scheduler: MainScheduler.instance)
            .bind(onNext: { _ in
                UIView.animate(withDuration: 0.5, animations: {
                    clearButton.alpha = 0
                })
            })
            .disposed(by: disposeBag)
    }

    private func setUpBannerView() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        bannerView = makeBannerView()
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        bannerView.alpha = 0
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

extension MainTimerViewController: MyIssueViewControllerDelegate {
    public func didSelect(issue: Issue?) {
        if let issue = issue {
            selectedIssue = issue
            buttonIssue.setTitle(issue.sumamry, for: .normal)
        } else {
            selectedIssue = nil
            buttonIssue.setTitle("Issues", for: .normal)
        }
    }
}
