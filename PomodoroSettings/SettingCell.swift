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
    var content: SettingContent { get }
}

public class AmountSettingCell: UITableViewCell, SettingCell {
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
