//
//  Interval.swift
//  Pomodoro
//
//  Created by 류성두 on 23/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

public protocol IntervalDelegate: class {
    func timeElapsed(_ seconds: TimeInterval)
    func intervalFinished(by finisher: IntervalFinisher)
}

public enum IntervalFinisher {
    case time
    case user
}

public protocol Interval {
    var delegate: IntervalDelegate? { get set }
    var isActive: Bool { get }
    var notiContent: UNMutableNotificationContent { get }
    var elapsedSeconds: TimeInterval { get set }
    var targetSeconds: TimeInterval { get }
    var targetMinute: TimeInterval { get }
    var themeColor: UIColor { get }

    func startTimer()
    func stopTimer(by finisher:IntervalFinisher)
    func pauseTimer()
}
