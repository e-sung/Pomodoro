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

    var cellToUpdate: BasicSettingTableViewCell!
    
    @IBAction func cloeButtonClicked(_ sender: UIButton) {
//        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var pickerView: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectRow(6, inComponent: 0, animated: false)
        
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
        let interval: Double = Double((row + 1) * 300 )
        return interval.toString(options: {
            $0.allowedUnits = [.minute]
            $0.unitsStyle = .short
        })
    }
    
}
