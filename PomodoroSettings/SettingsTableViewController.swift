//
//  SettingsTableViewController.swift
//  Pomodoro
//
//  Created by 류성두 on 29/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import UIKit
import PomodoroFoundation

public class SettingsTableViewController: UITableViewController {
    
    @IBOutlet var amountSettingCells: [AmountSettingCell]!
    @IBOutlet var toggleSettingCells: [ToggleSettingCell]!

    override public func viewDidLoad() {
        super.viewDidLoad()
        amountSettingCells.forEach({ [weak self] in self?.update($0) })
        toggleSettingCells.forEach({ [weak self] in self?.setUp($0) })

    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVC =  segue.destination as? PickerUpdater,
            let cellToUpdate = sender as? AmountSettingCell{
            nextVC.settingCell = cellToUpdate
        }
    }
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func update(_ cell: AmountSettingCell) {
        var amount = retreiveAmount(for: cell.content, from: UserDefaults.standard)
        if amount == 0, let defaultValue = cell.content.defaultValue as? Int {
            amount = defaultValue
        }
        guard let valueToUpdate = amount else { return }
        cell.update(for: valueToUpdate)
    }
    
    func setUp(_ cell: ToggleSettingCell) {
        if retreiveBool(for: cell.content, from: UserDefaults.standard) == nil {
            guard let defaultValue = cell.content.defaultValue as? Bool else { return }
            cell.setUp(for: defaultValue)
        }
    }
}
