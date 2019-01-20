//
//  PickerUpdater.swift
//  Pomodoro
//
//  Created by 류성두 on 30/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import Foundation
import PomodoroFoundation
import UIKit

protocol PickerUpdater: class {
    var pickerView: UIPickerView! { get }
    var settingCell: AmountSettingCell! { get set }
    var pickerTitle: String? { get set }
}
