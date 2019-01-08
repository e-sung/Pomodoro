//
//  SettingContent.swift
//  PomodoroFoundation
//
//  Created by 류성두 on 30/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import Foundation

public enum SettingContent:String {
    case focusTime = "focusIntervalSetting"
    case breakTime = "breakIntervalSetting"
    case longBreakTime = "longBreakIntervalSetting"
    case cycleForLongBreak = "cycleForLongBreakSetting"
    case target = "targetSetting"
    case neverSleep = "neverSleepSetting"
    case enhancedFocusMode = "enhancedFocusModeSetting"
    case devMode = "devModeSetting"

    public var defaultValue: Any {
        switch self {
        case .focusTime: return 25 as Any
        case .breakTime: return 5 as Any
        case .longBreakTime: return 15 as Any
        case .cycleForLongBreak: return 3 as Any
        case .target: return 10 as Any
        case .neverSleep: return true as Any
        case .enhancedFocusMode: return false as Any
        case .devMode: return false as Any
        }
    }
    
    public var numberOfCases: Int? {
        switch self {
        case .target: return 50
        case .cycleForLongBreak: return 50
        case .focusTime, .breakTime, .longBreakTime: return 12
        default: return nil
        }
    }
    
    public func formattedString(given amount: Int) -> String? {
        switch self {
        //TODO: Localize!
        case .target: return "\(amount) intervals"
        case .cycleForLongBreak: return "\(amount) cycles"
        case .focusTime, .breakTime, .longBreakTime:
            return amount.minuteString
        default: return nil
        }
    }
    
    public func amount(for row: Int) -> Int? {
        switch self {
        case .target, .cycleForLongBreak: return row + 1
        case .focusTime, .breakTime, .longBreakTime : return (row + 1) * 5
        default: return nil
        }
    }
    
    public func rowFor(_ amount: Int) -> Int? {
        switch self {
        case .target, .cycleForLongBreak: return amount - 1
        case .focusTime, .breakTime, .longBreakTime : return Int((amount / 5)) - 1
        default: return nil
        }
    }
}
