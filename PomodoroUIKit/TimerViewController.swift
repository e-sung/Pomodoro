import AudioToolbox
import Foundation
import PomodoroFoundation
import UIKit
import UserNotifications

open class TimerViewController: UIViewController, IntervalDelegate {
    // MAKR: Views
    @IBOutlet public var labelTime: UILabel!

    // MARK: Properties

    public var interval: Interval {
        get {
            return IntervalManager.shared!
        }
        set {
            IntervalManager.shared = newValue
        }
    }

    public var maxCycleCount: Int {
        return retreiveAmount(for: .target, from: UserDefaults(suiteName: "group.pomodoro.com")!)!
    }

    public var currentCycleCount = 0
    public var cycleCountForLongBreak = 3
    public var notificationManager: NotificationManager!

    // MARK: UIViewController

    open override func viewDidLoad() {
        super.viewDidLoad()
        setUpInitialValue()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interval.delegate = self
        notificationManager = NotificationManager(delegate: self)
        refreshViews(with: interval)
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpFonts()
    }

    open override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { [weak self] _ in
            self?.setUpFonts()
        })
    }

    // MARK: Public Functions

    open func refreshViews(with interval: Interval) {
        updateLabelTime(with: interval.elapsedSeconds)
    }

    // MARK: IntervalDelegate

    open func timeElapsed(_ seconds: TimeInterval) {
        updateLabelTime(with: seconds)
    }

    open func intervalFinished(by finisher: IntervalFinisher, isFromBackground: Bool) {
        if finisher == .time, interval is BreakInterval {
            currentCycleCount += 1
            saveCycles(currentCycleCount, to: UserDefaults(suiteName: "group.pomodoro.com")!)
        }

        if isFromBackground == false {
            notificationManager.publishNotiContent(of: interval, via: UNUserNotificationCenter.current())
        }

        resetInterval()
        refreshViews(with: interval)
    }
}

// MARK: SetUp

extension TimerViewController {
    func setUpInitialValue() {
        interval.delegate = self
        resetCycleIfDayHasPassed()
        currentCycleCount = retreiveCycle(from: UserDefaults(suiteName: "group.pomodoro.com")!)
    }

    func setUpFonts() {
        let currentFontSize = labelTime.font.pointSize
        labelTime.font = UIFont.monospacedDigitSystemFont(ofSize: currentFontSize, weight: .thin)
    }
}

// MARK: Update

extension TimerViewController {
    @objc open func startOrStopTimer() {
        let popVibration = SystemSoundID(1520)
        AudioServicesPlaySystemSound(popVibration)
        if interval.isActive {
            interval.pauseTimer()
        } else {
            resetCycleIfDayHasPassed()
            interval.startTimer()
        }
    }

    public func updateLabelTime(with seconds: TimeInterval) {
        guard seconds <= interval.targetSeconds else { return }
        let date = Date(timeIntervalSince1970: interval.targetSeconds - seconds)
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("mm:ss")
        labelTime.text = dateFormatter.string(from: date)

        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.minute, .second]
        formatter.string(from: date.timeIntervalSince1970)

        labelTime.accessibilityLabel = NSLocalizedString("remainingTime", comment: "")
            + formatter.string(from: date.timeIntervalSince1970)!
    }

    @objc open func applyNewSetting() {
        if interval.isActive == false {
            applyNewSettingForInterval()
        }
    }

    func applyNewSettingForInterval() {
        if interval is FocusInterval {
            interval = FocusInterval()
        } else if interval is BreakInterval {
            interval = BreakInterval()
        } else if interval is LongBreakInterval {
            interval = LongBreakInterval()
        }
        interval.delegate = self
        refreshViews(with: interval)
    }
}

// MARK: Resetting

extension TimerViewController {
    public func resetInterval() {
        if interval is FocusInterval {
            if (currentCycleCount + 1) % cycleCountForLongBreak == 0 {
                interval = LongBreakInterval()
                interval.delegate = self
            } else {
                interval = BreakInterval()
                interval.delegate = self
            }
        } else if interval is BreakInterval {
            interval = FocusInterval()
            interval.delegate = self
        }
    }

    func resetCycleIfDayHasPassed() {
        let latestCycleDate = retreiveLatestCycleDate(from: UserDefaults(suiteName: "group.pomodoro.com")!)
        if latestCycleDate.isYesterday {
            currentCycleCount = 0
            saveCycles(currentCycleCount, date: Date(), to: UserDefaults(suiteName: "group.pomodoro.com")!)
        }
    }
}

// MARK: UserNotificationExtension

extension TimerViewController: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "background.noti" {
            intervalFinished(by: .time, isFromBackground: true)
            if response.actionIdentifier != "com.apple.UNNotificationDefaultActionIdentifier" {
                registerBackgroundTimer(with: interval)
            }
        } else {
            startOrStopTimer()
        }
        completionHandler()
    }

    public func userNotificationCenter(_: UNUserNotificationCenter, willPresent _: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
}

// MARK: Etc

fileprivate extension Date {
    var isYesterday: Bool {
        return day != Date().day
    }

    var day: String {
        let formatter = DateFormatter.standard
        formatter.dateFormat = "dd"
        return formatter.string(from: self)
    }
}
