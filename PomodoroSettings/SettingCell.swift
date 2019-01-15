//
//  BasicSettingTableViewCell.swift
//  Pomodoro
//
//  Created by 류성두 on 30/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import PomodoroFoundation
import UIKit

public class AmountSettingCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    public var content: SettingContent {
        return SettingContent(rawValue: accessibilityIdentifier!)!
    }

    public func update(for amount: Int) {
        amountLabel.text = content.formattedString(given: amount)
        save(amount, for: content, to: UserDefaults(suiteName: "group.pomodoro.com")!)
    }
}

public class ToggleSettingCell: UITableViewCell {
    @IBOutlet var toggleSwitch: UISwitch!
    public var content: SettingContent {
        return SettingContent(rawValue: accessibilityIdentifier!)!
    }

    @IBAction func switchToggled(_ sender: UISwitch) {
        save(sender.isOn, for: content, to: UserDefaults(suiteName: "group.pomodoro.com")!)
    }

    public func setUp(for value: Bool) {
        toggleSwitch.isOn = value
    }
}
