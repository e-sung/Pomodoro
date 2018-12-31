//
//  SettingsTableViewController.swift
//  Pomodoro
//
//  Created by 류성두 on 29/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import UIKit

public class SettingsTableViewController: UITableViewController {
    
    @IBOutlet var settingCells: [AmountSettingCell]!
    override public func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44

        settingCells.forEach({ [weak self] in self?.update($0) })

    }
    

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVC =  segue.destination as? PickerUpdater,
            let cellToUpdate = sender as? SettingCell{
            nextVC.settingCell = cellToUpdate
        }
    }
    
    func update(_ cell: AmountSettingCell) {
        var amount = UserDefaults.standard.integer(forKey: cell.content.rawValue)
        if amount == 0, let defaultValue = cell.content.defaultValue as? Int {
            amount = defaultValue
        }
        cell.update(for: amount)
    }
}
