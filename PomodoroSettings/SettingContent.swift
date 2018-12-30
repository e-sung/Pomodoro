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
    case target = "targetSetting"
    
    public var defaultAmount: Int {
        switch self {
        case .focusTime: return 25
        case .breakTime: return 5
        case .longBreakTime: return 15
        case .target: return 10
        }
    }
    
    public var numberOfCases: Int {
        switch self {
        case .target: return 50
        default: return 12
        }
    }
    
    public func formattedString(given amount: Int) -> String {
        switch self {
        //TODO: Localize!
        case .target: return "\(amount) intervals"
        default: return amount.minuteString
        }
    }
}
