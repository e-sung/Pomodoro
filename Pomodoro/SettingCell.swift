//
//  BasicSettingTableViewCell.swift
//  Pomodoro
//
//  Created by 류성두 on 30/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import UIKit
import PomodoroFoundation

protocol SettingCell: class {
    func update(for amount: Int)
    var updating: SettingContent { get }
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
