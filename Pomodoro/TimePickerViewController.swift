//
//  TimePickerViewController.swift
//  Pomodoro
//
//  Created by 류성두 on 29/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import UIKit
import SwiftDate

class TimePickerViewController: UIViewController {

    weak var cellToUpdate: BasicSettingTableViewCell!
    
    @IBAction func cloeButtonClicked(_ sender: UIButton) {
//        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var pickerView: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        let userDefaultMinute = retreiveMinute(from: UserDefaults.standard)
        pickerView.selectRow(rowFor(userDefaultMinute), inComponent: 0, animated: false)
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonClicked(_ sender: UIButton) {
        let currentRow = pickerView.selectedRow(inComponent: 0)
        let minuteToSave = selectedMinute(for: currentRow)
        cellToUpdate.update(for: minuteToSave)
        save(minuteToSave, to: UserDefaults.standard)
        dismiss(animated: true, completion: nil)
    }
    
    func save(_ minute: Int, to userDefault: UserDefaults) {
        Pomodoro.save(minute, for: cellToUpdate.cellType, to: userDefault)
    }

    func retreiveMinute(from userDefault: UserDefaults) -> Int {
        return Pomodoro.retreiveMinute(for: cellToUpdate.cellType, from: userDefault)
    }
}

extension TimePickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 12
    }
}

extension TimePickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return selectedMinute(for: row).minuteString
    }
    
    func selectedMinute(for row: Int) -> Int {
        return (row + 1) * 5
    }
    
    func rowFor(_ minute: Int) -> Int {
        return Int((minute / 5)) - 1
    }
}
