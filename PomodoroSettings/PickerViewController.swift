//
//  TimePickerViewController.swift
//  Pomodoro
//
//  Created by 류성두 on 29/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import UIKit
import PomodoroFoundation

public class PickerViewController: UIViewController, PickerUpdater {

    weak var settingCell: AmountSettingCell!

    @IBOutlet var pickerView: UIPickerView!
    override public func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        let defaultAmount = retreiveAmount(for: settingCell.content, from: UserDefaults.standard)
        guard let defaultRow = settingCell.content.rowFor(defaultAmount) else { return }
        pickerView.selectRow(defaultRow, inComponent: 0, animated: false)
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        close()
    }
    
    @IBAction func doneButtonClicked(_ sender: UIButton) {
        let currentRow = pickerView.selectedRow(inComponent: 0)
        if let amountToSave = settingCell.content.amount(for: currentRow) {
            settingCell.update(for: amountToSave)
        }
        close()
    }
    
    func close() {
        dismiss(animated: true, completion: { [weak self] in
            guard let cell = self?.settingCell as? UITableViewCell else { return }
            cell.setSelected(false, animated: true)
        })
    }
}

// MARK: PickerViewDataSource
extension PickerViewController: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return settingCell.content.numberOfCases!
    }
}

// MARK: PickerViewDelegate
extension PickerViewController: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let amount = settingCell.content.amount(for: row) else { return nil }
        return settingCell.content.formattedString(given: amount)
    }
}
