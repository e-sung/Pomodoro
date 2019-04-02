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
    }

    @IBAction func buttonFloatClicked(_: UIButton) {
        let title = LoremIpsum.generateRandomWords(withLength: UInt.random(in: 1 ... 5))!
        let content = LoremIpsum.generateRandomWords(withLength: UInt.random(in: 10 ... 50))!
        let historyItem = History(title: title, content: content, startTime: Date(), endTime: Date())

        let historyMO = HistoryMO(entity: HistoryMO.entity(), insertInto: context)
        historyMO.setUp(with: historyItem)
        appDelegate.saveContext()
        fetchedHistories.append(historyMO)
        tableView.reloadData()
    }
    
    override func delete(history: HistoryMO) {
        context.delete(history)
        fetchedHistories.removeAll(where: { $0.startDate == history.startDate })
        try? context.save()
        tableView.reloadData()
    }
    
}
