//
//  BasicSettingTableViewCell.swift
//  Pomodoro
//
//  Created by 류성두 on 30/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import UIKit

protocol SettingCell: class {
    func update(for amount: Int)
    var updating: SettingContent { get }
}

enum SettingContent:String {
    case focusTime = "focusIntervalSetting"
    case breakTime = "breakIntervalSetting"
    case longBreakTime = "longBreakIntervalSetting"
    case target = "targetSetting"
    
    var defaultAmount: Int {
        switch self {
        case .focusTime: return 25
        case .breakTime: return 5
        case .longBreakTime: return 15
        case .target: return 10
        }
    }
    
    var numberOfCases: Int {
        switch self {
        case .target: return 50
        default: return 12
        }
    }
    
    func formattedString(given amount: Int) -> String {
        switch self {
        //TODO: Localize!
        case .target: return "\(amount) intervals"
        default: return amount.minuteString
        }
    
    }
}

class MinuteSettingCell: UITableViewCell, SettingCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    var updating: SettingContent {
        return SettingContent(rawValue: accessibilityIdentifier!)!
    }
    
    func update(for amount: Int) {
        amountLabel.text = amount.minuteString
    }
}

class TargetSettingCell: UITableViewCell, SettingCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    var updating: SettingContent {
        return SettingContent(rawValue: accessibilityIdentifier!)!
    }
    
    func update(for amount: Int) {
        amountLabel.text = "\(amount) interval"
    }
}
