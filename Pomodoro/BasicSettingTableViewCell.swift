//
//  BasicSettingTableViewCell.swift
//  Pomodoro
//
//  Created by 류성두 on 30/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import UIKit

class BasicSettingTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    var cellType: TYPE!


    override func awakeFromNib() {
        super.awakeFromNib()
        guard let identifier = accessibilityIdentifier else { return }
        cellType = TYPE(rawValue: identifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    enum TYPE:String {
        case focusTime = "focusIntervalSetting"
        case breakTime = "breakIntervalSetting"
        case longBreakTime = "longBreakIntervalSetting"
        case target = "targetSetting"
    }
}
