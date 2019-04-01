//
//  Interval.swift
//  Pomodoro
//
//  Created by 류성두 on 23/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

public class IntervalManager {
    public static var shared: Interval?
}

public protocol IntervalDelegate: class {
    func timeElapsed(_ seconds: TimeInterval)
    func intervalFinished(by finisher: IntervalFinisher, isFromBackground: Bool)
}

public enum IntervalFinisher {
    case time
    case user
}

public protocol Interval: class {
    var timer: Timer { get set }
    var delegate: IntervalDelegate? { get set }
    var isActive: Bool { get }
    var notiContent: UNMutableNotificationContent { get }
    var notiAction: UNNotificationAction { get }
    var elapsedSeconds: TimeInterval { get set }
    var targetSeconds: TimeInterval { get }
    var targetMinute: TimeInterval { get }
    var themeColor: ThemeColorSet { get }
    var typeIdentifier: String { get }

    func startTimer()
    func stopTimer(by finisher: IntervalFinisher)
    func pauseTimer()
}

extension Interval {
    public var isActive: Bool {
        return timer.isValid
    }

    public func startOrPauseTimer() {
        if isActive {
            pauseTimer()
        } else {
            startTimer()
        }
    }

    public func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.elapsedSeconds += 1
            strongSelf.delegate?.timeElapsed(strongSelf.elapsedSeconds)
            if strongSelf.elapsedSeconds > strongSelf.targetSeconds {
                strongSelf.stopTimer(by: .time)
            }
        })
    }

    public func stopTimer(by finisher: IntervalFinisher = .user) {
        timer.invalidate()
        elapsedSeconds = 0
        delegate?.intervalFinished(by: finisher, isFromBackground: false)
    }

    public func pauseTimer() {
        timer.invalidate()
    }

    public var targetSeconds: TimeInterval {
        return isDevMode ? targetMinute : 60 * targetMinute
    }
}
