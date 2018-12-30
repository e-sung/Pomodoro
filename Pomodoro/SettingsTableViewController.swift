//
//  SettingsTableViewController.swift
//  Pomodoro
//
//  Created by 류성두 on 29/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet var focusIntervalCell: BasicSettingTableViewCell!
    @IBOutlet var breakIntervalCell: BasicSettingTableViewCell!
    @IBOutlet var longBreakIntervalCell: BasicSettingTableViewCell!
    
    @IBOutlet var minuteCells: [BasicSettingTableViewCell]!
    @IBOutlet var targetCell: BasicSettingTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        minuteCells.forEach({ [weak self] in self?.updateMinuteValue(for: $0) })
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVC =  segue.destination as? TimePickerViewController,
            let cellToUpdate = sender as? BasicSettingTableViewCell{
            nextVC.cellToUpdate = cellToUpdate
        }
    }
    
    @IBAction func unwindToSettingsViewController(_ unwindSegue: UIStoryboardSegue) {
    }
    
    func updateMinuteValue(for cell: BasicSettingTableViewCell) {
        var minuteValue = UserDefaults.standard.integer(forKey: cell.cellType.rawValue)
        if minuteValue == 0 {
            minuteValue = cell.cellType.defaultAmount
            UserDefaults.standard.set(minuteValue, forKey: cell.cellType.rawValue)
        }
        cell.update(for: minuteValue)
    }
}
