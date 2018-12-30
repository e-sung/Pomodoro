//
//  BasicSettingTableViewCell.swift
//  Pomodoro
//
//  Created by 류성두 on 30/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import UIKit
import PomodoroFoundation

public protocol SettingCell: class {
    func update(for amount: Int)
    var updating: SettingContent { get }
}

public class MinuteSettingCell: UITableViewCell, SettingCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    public var updating: SettingContent {
        return SettingContent(rawValue: accessibilityIdentifier!)!
    }
    
    public func update(for amount: Int) {
        amountLabel.text = amount.minuteString
    }
}

public class TargetSettingCell: UITableViewCell, SettingCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    public var updating: SettingContent {
        return SettingContent(rawValue: accessibilityIdentifier!)!
    }
    
    public func update(for amount: Int) {
        amountLabel.text = "\(amount) interval"
    }
}
