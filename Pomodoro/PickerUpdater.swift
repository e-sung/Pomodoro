//
//  PickerUpdater.swift
//  Pomodoro
//
//  Created by 류성두 on 30/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import Foundation
import UIKit

protocol PickerUpdater:class {
    var pickerView: UIPickerView! { get }
    var cellToUpdate: SettingCell! { get set }
    func selectedAmount(for row: Int) -> Int
    func rowFor(_ amount: Int) -> Int
    func saveResult()
}

extension PickerUpdater {
    func saveResult() {
        let currentRow = pickerView.selectedRow(inComponent: 0)
        let amountToSave = selectedAmount(for: currentRow)
        cellToUpdate.update(for: amountToSave)
        save(amountToSave, for: cellToUpdate.updating, to: UserDefaults.standard)
    }
    
    func selectedAmount(for row: Int) -> Int {
        if cellToUpdate.updating == .target {
            return row + 1
        }
        return (row + 1) * 5
    }
    
    func rowFor(_ amount: Int) -> Int {
        if cellToUpdate.updating == .target {
            return amount - 1
        }
        return Int((amount / 5)) - 1
    }
}
