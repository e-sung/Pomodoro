//
//  BasicSettingTableViewCell.swift
//  Pomodoro
//
//  Created by 류성두 on 30/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import UIKit
import PomodoroFoundation


public class AmountSettingCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    public var content: SettingContent {
        return SettingContent(rawValue: accessibilityIdentifier!)!
    }
    
    public func update(for amount: Int) {
        amountLabel.text = content.formattedString(given: amount)
        save(amount, for: content, to: UserDefaults.standard)
    }
}

public class ToggleSettingCell: UITableViewCell {
    
    @IBOutlet var toggleSwitch: UISwitch!
    public var content: SettingContent {
        return SettingContent(rawValue: accessibilityIdentifier!)!
    }
    
    @IBAction func switchToggled(_ sender: UISwitch) {
        save(sender.isOn, for: content, to: UserDefaults.standard)
    }
    
    public func setUp(for value: Bool) {
        toggleSwitch.isOn = value
    }
}
