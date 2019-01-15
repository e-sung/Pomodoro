import AudioToolbox
import Foundation
import HGCircularSlider
import PomodoroFoundation
import PomodoroSettings
import UIKit
import UserNotifications

public class TimerViewController: UIViewController, IntervalDelegate {
    // MAKR: Views
    @IBOutlet var labelTime: UILabel!

    // MARK: Properties

    public var interval: Interval! = IntervalManager.shared
    public var notificationManager: NotificationManager!
    public var maxCycleCount: Int {
        return retreiveAmount(for: .target, from: UserDefaults.standard)!
    }

    public var currentCycleCount = 0
    public var cycleCountForLongBreak = 3

    // MARK: UIViewController

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpInitialValue()
        refreshViews(with: interval)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpFonts()
        let shouldPreventSleep = retreiveBool(for: SettingContent.neverSleep, from: UserDefaults.standard)
        UIApplication.shared.isIdleTimerDisabled = shouldPreventSleep ?? true
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setUpFonts()
    }

    // MARK: Public Functions
    
    public func refreshViews(with interval: Interval) {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.view.backgroundColor = interval.themeColor.backgroundColor
        })
        updateLabelTime(with: interval.elapsedSeconds)
    }

    // MARK: IntervalDelegate

    public func timeElapsed(_ seconds: TimeInterval) {
        updateLabelTime(with: seconds)
    }

    public func intervalFinished(by finisher: IntervalFinisher) {
        notificationManager.publishNotiContent(of: interval, via: UNUserNotificationCenter.current())

        if finisher == .time, interval is BreakInterval {
            currentCycleCount += 1
            saveCycles(currentCycleCount, to: UserDefaults.standard)
        }

        resetInterval()
        refreshViews(with: interval)
    }
}

// MARK: SetUp
extension TimerViewController {
    func setUpInitialValue() {
        notificationManager = NotificationManager(delegate: self)
        if let savedInterval = retreiveInterval(from: UserDefaults.standard) {
            interval = savedInterval
            interval.delegate = self
        } else {
            interval = FocusInterval(intervalDelegate: self)
        }
        
        resetIntervalContext(on: UserDefaults.standard)
        resetCycleIfDayHasPassed()
        currentCycleCount = retreiveCycle(from: UserDefaults.standard)
    }
    
    func setUpFonts() {
        let currentFontSize = labelTime.font.pointSize
        labelTime.font = UIFont.monospacedDigitSystemFont(ofSize: currentFontSize, weight: .light)
    }
}

// MARK: Update

extension TimerViewController {
    func startOrStopTimer() {
        let popVibration = SystemSoundID(1520)
        AudioServicesPlaySystemSound(popVibration)
        if interval.isActive {
            interval.pauseTimer()
        } else {
            resetCycleIfDayHasPassed()
            interval.startTimer()
        }
    }
    
    func updateLabelTime(with seconds: TimeInterval) {
        guard seconds <= interval.targetSeconds else { return }
        let date = Date(timeIntervalSince1970: interval.targetSeconds - seconds)
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("mm:ss")
        labelTime.text = dateFormatter.string(from: date)
    }
    
    func applyNewSetting() {
        if interval.isActive == false {
            applyNewSettingForInterval()
        }
        
        let shouldPreventSleep = retreiveBool(for: SettingContent.neverSleep, from: UserDefaults.standard)
        UIApplication.shared.isIdleTimerDisabled = shouldPreventSleep ?? true
    }
    
    func applyNewSettingForInterval() {
        if interval is FocusInterval {
            interval = FocusInterval(intervalDelegate: self)
        } else if interval is BreakInterval {
            interval = BreakInterval(intervalDelegate: self)
        } else if interval is LongBreakInterval {
            interval = LongBreakInterval(intervalDelegate: self)
        }
        refreshViews(with: interval)
    }
}

// MARK: Resetting
extension TimerViewController {
    func resetInterval() {
        if interval is FocusInterval {
            if (currentCycleCount + 1) % cycleCountForLongBreak == 0 {
                interval = LongBreakInterval(intervalDelegate: self)
            } else {
                interval = BreakInterval(intervalDelegate: self)
            }
        } else if interval is BreakInterval {
            interval = FocusInterval(intervalDelegate: self)
        }
    }

    func resetCycleIfDayHasPassed() {
        let latestCycleDate = retreiveLatestCycleDate(from: UserDefaults.standard)
        if latestCycleDate.isYesterday {
            currentCycleCount = 0
            saveCycles(currentCycleCount, date: Date(), to: UserDefaults.standard)
        }
    }
}

// MARK: UserNotificationExtension

extension TimerViewController: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "background.noti" {
            intervalFinished(by: .time)
            if response.actionIdentifier != "com.apple.UNNotificationDefaultActionIdentifier" {
                registerBackgroundTimer()
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
