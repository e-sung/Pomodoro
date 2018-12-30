//
//  SettingsTableViewController.swift
//  Pomodoro
//
//  Created by 류성두 on 29/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet var settingCells: [UITableViewCell]!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44

        settingCells.compactMap({ $0 as? SettingCell })
                    .forEach({ [weak self] in self?.update($0) })

    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVC =  segue.destination as? PickerUpdater,
            let cellToUpdate = sender as? SettingCell{
            nextVC.cellToUpdate = cellToUpdate
        }
    }
    
    func update(_ cell: SettingCell) {
        var defaultValue = UserDefaults.standard.integer(forKey: cell.updating.rawValue)
        if defaultValue == 0 {
            defaultValue = cell.updating.defaultAmount
            UserDefaults.standard.set(defaultValue, forKey: cell.updating.rawValue)
        }
        cell.update(for: defaultValue)
    }
}
