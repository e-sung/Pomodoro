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

    weak var cellToUpdate: SettingCell!

    @IBOutlet var pickerView: UIPickerView!
    override public func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        let userDefaultMinute = retreiveAmount(for: cellToUpdate.updating, from: UserDefaults.standard)
        pickerView.selectRow(rowFor(userDefaultMinute), inComponent: 0, animated: false)
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        close()
    }
    
    @IBAction func doneButtonClicked(_ sender: UIButton) {
        saveResult()
        close()
    }
    
    func close() {
        dismiss(animated: true, completion: { [weak self] in
            guard let cell = self?.cellToUpdate as? UITableViewCell else { return }
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
        return cellToUpdate.updating.numberOfCases
    }
}

// MARK: PickerViewDelegate
extension PickerViewController: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let amount = selectedAmount(for: row)
        return cellToUpdate.updating.formattedString(given: amount)
    }
}
