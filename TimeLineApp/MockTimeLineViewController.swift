//
//  MockTimeLineViewController.swift
//  TimeLineApp
//
//  Created by 류성두 on 12/03/2019.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import LoremIpsum_iOS
import PomodoroFoundation
import PomodoroUIKit
import TimeLine
import UIKit

class MockTimeLineViewController: TimelineViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchedHistories = try! context.fetch(HistoryMO.fetchRequest())
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
    }

    @IBAction func buttonFloatClicked(_: UIButton) {
        let title = LoremIpsum.generateRandomWords(withLength: UInt.random(in: 1 ... 5))!
        let content = LoremIpsum.generateRandomWords(withLength: UInt.random(in: 10 ... 50))!

        let historyMO = HistoryMO(entity: HistoryMO.entity(), insertInto: context)
        historyMO.setUp(title: title, content: content, startTime: Date(), endTime: Date())
        appDelegate.saveContext()
        fetchedHistories.append(historyMO)
        tableView.reloadData()
    }
    
    @IBAction func buttonAddNewItemClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Congratulation!", message: "Add Memo?", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.addNewItem(with: alert)
        })
        
        let noAction = UIAlertAction(title: "No", style: .default, handler: { [weak self] _ in
            self?.addNewItem(with: alert)
        })
        
        alert.addAction(noAction)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func addNewItem(with alert: UIAlertController) {
        let memo = alert.textFields?.first?.text ?? "-"
        let historyMO = HistoryMO(entity: HistoryMO.entity(), insertInto: context)
        historyMO.setUp(title: titleText, content: memo, startTime: Date(), endTime: Date())
        appDelegate.saveContext()
        fetchedHistories.append(historyMO)
        tableView.reloadData()
        scrollToBottom()
    }
    
    private func scrollToBottom() {
        let itemCount = fetchedHistories.count
        let indexPath = IndexPath(row: itemCount - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    
    override func delete(history: HistoryMO) {
        context.delete(history)
        fetchedHistories.removeAll(where: { $0.startDate == history.startDate })
        try? context.save()
        tableView.reloadData()
    }
    
}
