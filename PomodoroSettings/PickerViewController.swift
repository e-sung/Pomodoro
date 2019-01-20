//
//  TimePickerViewController.swift
//  Pomodoro
//
//  Created by 류성두 on 29/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import PomodoroFoundation
import UIKit

public class PickerViewController: UIViewController, PickerUpdater {
    weak var settingCell: AmountSettingCell!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var buttonDone: UIButton!
    @IBOutlet var buttonCancel: UIButton!
    var pickerTitle: String?

    public override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        guard let defaultAmount = retreiveAmount(for: settingCell.content, from: UserDefaults(suiteName: "group.pomodoro.com")!) else { return }
        guard let defaultRow = settingCell.content.rowFor(defaultAmount) else { return }
        pickerView.selectRow(defaultRow, inComponent: 0, animated: false)
        view.accessibilityElements = [pickerView, buttonDone, buttonCancel]
    }

    @IBAction func cancelButtonClicked(_: Any) {
        close()
    }

    @IBAction func doneButtonClicked(_: UIButton) {
        let currentRow = pickerView.selectedRow(inComponent: 0)
        if let amountToSave = settingCell.content.amount(for: currentRow) {
            settingCell.update(for: amountToSave)
        }
        close()
    }

    func close() {
        dismiss(animated: true, completion: { [weak self] in
            self?.settingCell.setSelected(false, animated: true)
        })
    }
}

// MARK: PickerViewDataSource

extension PickerViewController: UIPickerViewDataSource {
    public func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        return settingCell.content.numberOfCases!
    }
}

// MARK: PickerViewDelegate

extension PickerViewController: UIPickerViewDelegate {
    public func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        guard let amount = settingCell.content.amount(for: row) else { return nil }
        return settingCell.content.formattedString(given: amount)
    }
}
